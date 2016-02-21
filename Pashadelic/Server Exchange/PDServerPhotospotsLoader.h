//
//  PDServerPhotospotsLoader.h
//  Pashadelic
//
//  Created by LTT on 6/17/14.
//
//

#import "PDServerExchange.h"
#import "PDLocation.h"
@interface PDServerPhotospotsLoader :PDServerExchange

- (void)getPhotospotsInLocation:(PDLocation *)location sortType:(NSInteger)sort page:(NSInteger)page;

@end
