//
//  PDServerGoogleExchange.m
//  Pashadelic
//
//  Created by TungNT2 on 11/15/13.
//
//

#import "PDServerGoogleExchange.h"
#import "PDPlace.h"

@interface PDServerGoogleExchange ()
@property (assign, nonatomic) BOOL finished;
@end
@implementation PDServerGoogleExchange
@synthesize finished;

- (BOOL)parseResponseData
{
	if (!responseData) return NO;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
	if (self.debugMode) {
		NSLog(@"%@\n%@", self.URLString, response);
	}
    
    if (!response) {
		NSLog(@"%@\n%@", self.URLString, response);
		if (self.HTTPStatusCode != 0) {
			self.errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Server error %zd", nil), self.HTTPStatusCode];
		} else {
			self.errorDescription = NSLocalizedString(@"Error while parsing server response", nil);
		}
		return NO;
	}
	
    if ([[response stringForKey:@"status"] isEqualToString:@"OK"]) {
        [self loadResultFromResponse:response];
        return YES;
    } else {
		NSLog(@"%@\n%@", self.URLString, response);
		self.errorDescription = [response objectForKey:@"message"];
		if (![self.errorDescription isKindOfClass:NSString.class]) {
			self.errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Unknown error:\n%@", nil), response];
		}
		return NO;
	}
    return NO;
}

- (NSString *)serverAddress
{
    return kPDGoogleAddress;
}

- (void)requestToGetFunctionWithString:(NSString *)get
{
    finished = NO;
    [super requestToGetFunctionWithString:get];
    while (!finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    finished = YES;
    [super connectionDidFinishLoading:connection];
}

- (void)loadResultFromResponse:(NSDictionary *)response
{
}

- (NSArray *)loadPlacesAddressFromResult
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dictPlace in self.result) {
        if ([dictPlace isKindOfClass:[NSDictionary class]]) {
            NSString *address = [dictPlace objectForKey:@"description"];
            [array addObject:address];
        }
    }
    return array;
}

- (NSArray *)loadPlacesFromResult
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dictPlace in self.result) {
        if ([dictPlace isKindOfClass:[NSDictionary class]]) {
            PDPlace *place = [[PDPlace alloc] init];
            [place loadDataFromDictionary:dictPlace];
            [array addObject:place];
        }
    }
    return array;
}

- (NSArray *)loadGeoDataFromResult
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dictGeo in self.result) {
        if ([dictGeo isKindOfClass:[NSDictionary class]]) {
            PDPlace *place = [[PDPlace alloc] init];
            [place loadGeoDataFromDictionary:dictGeo];
            [array addObject:place];
        }
    }
    return array;
}

@end
