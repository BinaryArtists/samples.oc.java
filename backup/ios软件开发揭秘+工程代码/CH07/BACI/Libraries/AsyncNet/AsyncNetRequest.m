#import "AsyncNetRequest.h"

@implementation AsyncNetRequest

@synthesize successTarget;
@synthesize successAction;
@synthesize failureTarget;
@synthesize failureAction;
@synthesize userInfo;
@synthesize active;
@synthesize data;

- (id)init
{
    if (self = [super init])
    {
        data = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [data release];
    [super dealloc];
}

@end
