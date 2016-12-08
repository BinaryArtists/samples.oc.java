
import Foundation

open class Circuit<ImpulseType: Impulse> {  // Signal
    fileprivate var etches = [Etch<ImpulseType>]()
    
    fileprivate let impulseQueue: DispatchQueue = DispatchQueue(label: "circuit_impulse_queue", attributes: [])
    fileprivate let defaultDispatchQueue: DispatchQueue = DispatchQueue(label: "circuit_default_dispatch_queue", attributes: DispatchQueue.Attributes.concurrent)
    
    public init() { }
    
    /// Add an etch to this circuit from any thread.
    open func addEtch(_ etch: Etch<ImpulseType>) {
        impulseQueue.async { _ in
            self.etches.append(etch)
        }
    }
    
    /// Send an impulse from any thread.
    open func sendImpulse(_ impulse: ImpulseType) {
        impulseQueue.async { _ in
            self.recursiveSendImpulseToEtches(impulse, etches: self.etches)
        }
    }
    
    fileprivate func sendImpulses(_ impulses: [ImpulseType]) {
        for impulse in impulses {
            self.sendImpulse(impulse)
        }
    }
    
    fileprivate func removeDeadEtch(_ deadEtch: Etch<ImpulseType>) {
        impulseQueue.async { _ in
            if let index = self.etches.index(of: deadEtch) {
                self.etches.remove(at: index)
            }
        }
    }
    
    fileprivate func recursiveSendImpulseToEtches(_ impulse: ImpulseType, etches: [Etch<ImpulseType>]) {
        if (etches.count == 0) {
            return
        }
        
        var remainingEtches = etches
        let currentEtch = remainingEtches.removeFirst()
        
        if (!currentEtch.alive()) {
            self.removeDeadEtch(currentEtch)
            recursiveSendImpulseToEtches(impulse, etches: remainingEtches)
            return
        }
        
        // if let filter = currentEtch.filter {
        //    if !filter(impulse) {
        //        recursiveSendImpulseToEtches(impulse, etches: remainingEtches)
        //        return
        //    }
        // }
        
        var value: AnyObject!
        if let unwrap = currentEtch.unwrap, let unwrappedValue = unwrap(impulse) {
            value = unwrappedValue
        } else {
            recursiveSendImpulseToEtches(impulse, etches: remainingEtches)
            return
        }
        
        let queue = currentEtch.queue ?? self.defaultDispatchQueue
        queue.async { _ in
            if let impulses = currentEtch.dispatch(value) {
                self.sendImpulses(impulses)
            }
        }
        
        self.recursiveSendImpulseToEtches(impulse, etches: remainingEtches)
        return
    }
}

public struct Etch<ImpulseType: Impulse> { // "Observer"
    /// A unique identifier for this Etch. For supporting equatable.
    fileprivate let id = UUID()
    
    /// When the etch should permanently cease to receieve impulses.
    fileprivate(set) internal var alive: (() -> Bool) = { true }
    
    /// Which impulses this etch should be dispatched for.
    // private(set) internal var filter: (ImpulseType -> Bool)? = nil
    
    /// Filters and unwraps the impulse.
    /// If this block returns nil, the dispatch block will not be called.
    fileprivate(set) internal var unwrap: ((ImpulseType) -> AnyObject?)? = nil
    
    /// Preferred scheduler to on which to run dispatch if necessary.
    /// If not provided, the circuit will run it on a default queue.
    fileprivate(set) internal var queue: DispatchQueue? = nil
    
    /// The code to run in response to a matching Impulse.
    fileprivate(set) internal var dispatch: ((AnyObject) -> [ImpulseType]?) = { _ in nil }
    
    public init() { }
    
    public func withAlive(_ block: @escaping (() -> Bool)) -> Etch {
        var etch = self
        etch.alive = block
        return etch
    }
    
    // internal func withFilter(block: (ImpulseType -> Bool)?) -> Etch {
    //    var etch = self
    //    etch.filter = block
    //    return etch
    // }
    
    public func withUnwrap(_ unwrap: ((ImpulseType) -> AnyObject?)?) -> Etch {
        var etch = self
        etch.unwrap = unwrap
        return etch
    }
    
    public func withQueue(_ queue: DispatchQueue?) -> Etch {
        var etch = self
        etch.queue = queue
        return etch
    }
    
    public func withDispatch(_ dispatch: @escaping ((AnyObject) -> [ImpulseType]?)) -> Etch {
        var etch = self
        etch.dispatch = dispatch
        return etch
    }
}

public extension Etch {
    public func withAliveHost(_ host: AnyObject) -> Etch {
        return self.withAlive { [weak host] in host != nil }
    }
}

extension Etch: Equatable {}
public func ==<T: Impulse>(lhs: Etch<T>, rhs: Etch<T>) -> Bool {
    return lhs.id == rhs.id
}

/// A message. Intended to be an enum type.
public protocol Impulse { } // "Event"

infix operator <++ { associativity right precedence 93 }
public func <++<ImpulseType: Impulse>(lhs: Circuit<ImpulseType>, rhs: Etch<ImpulseType>) {
    lhs.addEtch(rhs)
}
