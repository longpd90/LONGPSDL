//
//  PDServerGeoTagLoader.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.05.13.
//
//

#import "PDServerExchange.h"
#import "PDPOIItem.h"

@interface PDServerGeoTagLoader : PDServerExchange

- (void)loadGeoTagInfo:(PDPOIItem *)geoTag sorting:(NSString *)sorting page:(NSUInteger)page;

@end
