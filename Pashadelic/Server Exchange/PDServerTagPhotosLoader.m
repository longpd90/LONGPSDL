//
//  PDServerTagPhotosLoader.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.04.13.
//
//

#import "PDServerTagPhotosLoader.h"

@implementation PDServerTagPhotosLoader

- (void)loadTagPhotos:(PDTag *)tag page:(NSUInteger)page
{
	self.functionPath = @"tags.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?tag=%@&page=%d",tag.name, page]];
}

@end
