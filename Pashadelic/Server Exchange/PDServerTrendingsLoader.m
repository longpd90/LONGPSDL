//
//  PDServerTrendingsLoader.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.04.13.
//
//

#import "PDServerTrendingsLoader.h"

@implementation PDServerTrendingsLoader

- (void)loadTrendingsPage:(NSUInteger)page
{
	self.functionPath = @"trendings.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];

}

@end
