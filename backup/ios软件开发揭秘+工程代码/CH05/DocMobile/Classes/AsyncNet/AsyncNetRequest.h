//
//  AsyncNetRequest.h
//  WebDoc
//
//  Created by Henry Yu on 09-06-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

@interface AsyncNetRequest : NSObject
{
    id successTarget;
    SEL successAction;
    id failureTarget;
    SEL failureAction;
    NSDictionary *userInfo;
    
    BOOL active;
    NSMutableData *data;
}

@property (nonatomic, retain) id successTarget;
@property (nonatomic, assign) SEL successAction;
@property (nonatomic, retain) id failureTarget;
@property (nonatomic, assign) SEL failureAction;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, retain) NSMutableData *data;

- (id)init;

@end
