@interface AsyncNet : NSObject
{
    int activeRequestsCount;
    int concurrentRequestsLimit;
    // NSValue * with NSURLConnection * -> AsyncNetRequest *
    NSMutableDictionary *requests;
    NSMutableArray *queue; // NSURLConnection *
}

@property (nonatomic, assign) int concurrentRequestsLimit;

+ (AsyncNet *)instance;

- (id)init;

- (void)startRequest:(NSURLConnection *)con;
- (void)stopRequest:(NSURLConnection *)con;
- (void)queueRequest:(NSURLConnection *)con;
- (NSURLConnection *)dequeueRequest;
- (void)connectionEnded;

#pragma mark Public

- (NSURLConnection *)addRequest:(NSURLRequest *)req
    successTarget:(id)successTarget successAction:(SEL)successAction
    failureTarget:(id)failureTarget failureAction:(SEL)failureAction
    userInfo:(NSDictionary *)userInfo;
- (NSURLConnection *)addRequestForUrl:(NSString *)url
    successTarget:(id)successTarget successAction:(SEL)successAction
    failureTarget:(id)failureTarget failureAction:(SEL)failureAction
    userInfo:(NSDictionary *)userInfo;
- (void)cancelRequest:(NSURLConnection *)con;
- (void)cancelAllRequests;

@end
