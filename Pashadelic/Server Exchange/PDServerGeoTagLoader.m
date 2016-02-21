//
//  PDServerGeoTagLoader.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.05.13.
//
//

#import "PDServerGeoTagLoader.h"

@implementation PDServerGeoTagLoader

- (void)loadGeoTagInfo:(PDPOIItem *)geoTag sorting:(NSString *)sorting page:(NSUInteger)page
{
	self.functionPath = [NSString stringWithFormat:@"gtags/%zd.json", geoTag.identifier];
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?sorting=%@&page=%zd", sorting, page]];
}

@end
