//
//  LongTaskOperation.h
//  NSOperationTest
//
//  Created by Henry Yu on 10-11-02.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LongTaskOperationDelegate;
@interface LongTaskOperation : NSOperation {
@private
   NSString	*iImageFilePath;
   id<LongTaskOperationDelegate> taskDelegate;
}
@property(nonatomic,assign) id<LongTaskOperationDelegate> taskDelegate;
-(id) initWithPath:(NSString*)aPath;
@end


@protocol LongTaskOperationDelegate<NSObject>
-(void) longTaskOperationFinished:(LongTaskOperation*)op;
@end