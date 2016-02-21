//
//  PDServerUpcomingLoader.m
//  Pashadelic
//
//  Created by TungNT2 on 6/5/14.
//
//

#import "PDServerUpcomingLoader.h"

@implementation PDServerUpcomingLoader

- (void)loadUpcomingPage:(NSUInteger)page
{
    [self setFunctionPath:@"upcomings.json"];
    [self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];
}

- (void)loadUpcomingPage:(NSUInteger)page firstPhotoId:(NSUInteger)photoId
{
    [self setFunctionPath:@"upcomings.json"];
    [self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd&check=%zd", page, photoId]];
}

@end
