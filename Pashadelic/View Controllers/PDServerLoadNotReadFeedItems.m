//
//  PDServerLoadNotReadFeedItems.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.12.12.
//
//

#import "PDServerLoadNotReadFeedItems.h"

@implementation PDServerLoadNotReadFeedItems

- (void)loadNotReadFeedItems
{
    self.functionPath = @"news/unread.json";
    [self requestToGetFunctionWithString:nil];
}

@end
