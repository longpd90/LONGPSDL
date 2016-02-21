//
//  PDServerPlansLoader.m
//  Pashadelic
//
//  Created by LongPD on 11/14/13.
//
//

#import "PDServerPlansLoader.h"

@implementation PDServerPlansLoader

- (void)loadPlansCount
{
    self.functionPath = @"plans.json?count=true";
	[self requestToGetFunctionWithString:nil];
}

- (void)loadPlansUpcoming:(NSInteger)page
{
    self.functionPath = @"plans.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];
}

- (void)loadPlansAll:(NSInteger)page
{
    self.functionPath = @"plans.json?all=true";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];
}

@end
