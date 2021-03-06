//
//  YJVisitor.swift
//  DesignPattern
//
//  CSDN:http://blog.csdn.net/y550918116j
//  GitHub:https://github.com/937447974/Blog
//
//  Created by yangjun on 15/11/26.
//  Copyright © 2015年 阳君. All rights reserved.
//

import Cocoa

/// VisitableProtocol定义一个Accept操作，它以一个访问者为参数。
private protocol VisitableProtocol {
    
    func accept(visitor: VisitorProtocol)
    
}

/// FloatElement实现VisitableProtocol操作，该操作以一个访问者为参数
private class FloatElement: VisitableProtocol {
    
    private var fe:Float
    
    init(fe:Float) {
        self.fe = fe
    }
    
    func accept(visitor: VisitorProtocol) {
        visitor.visitFloat(self)
    }
    
}

/// StringElement实现VisitableProtocol操作，该操作以一个访问者为参数
private class StringElement: VisitableProtocol {
    
    private var se:String
    
    init(se:String) {
        self.se = se
    }
    
    func accept(visitor: VisitorProtocol) {
        visitor.visitString(self)
    }
    
}

// MARK: - 

/// VisitorProtocol为该对象结构中ConcreteElement的每一个类声明一个Visit操作
private protocol VisitorProtocol {
    
    func visitString(stringE: StringElement)
    
    func visitFloat(floatE: FloatElement)
    
    func visitCollection(collection: Array<VisitableProtocol>)
    
}

/// ConcreteVisitor实现每个由Visitor声明的操作
private class ConcreteVisitor: VisitorProtocol {
    
    func visitFloat(floatE: FloatElement) {
        print(floatE.fe)
    }
    
    func visitString(stringE: StringElement) {
        print(stringE.se)
    }
    
    func visitCollection(collection: Array<VisitableProtocol>) {
        for visitable in collection {
            visitable.accept(self)
        }
    }
    
}

// MARK: - 

/// 访问者模式
class YJVisitor: YJTestProtocol {

    func test() {
        let visitor = ConcreteVisitor()
        let se = StringElement(se: "abc")
        se.accept(visitor)
        let fe = FloatElement(fe: 1.5)
        fe.accept(visitor)
        print("====")
        let list: Array<VisitableProtocol> = [se, fe]
        visitor.visitCollection(list)
    }

}
