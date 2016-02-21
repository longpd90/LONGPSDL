//
//  PDServerCollectionsLoader.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.07.13.
//
//

#import "PDServerCollectionsLoader.h"

@implementation PDServerCollectionsLoader

- (void)loadCollectionsPage:(NSInteger)pageNumber
{
	self.functionPath = @"collections.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", pageNumber]];
}

@end
