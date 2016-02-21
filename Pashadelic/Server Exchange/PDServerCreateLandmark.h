//
//  PDCreateLandmark.h
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/7/14.
//
//

#import "PDServerExchange.h"
#import "PDPOIItem.h"
@interface PDServerCreateLandmark : PDServerExchange
- (void)createLandmark:(PDPOIItem *)landmark;
@end
