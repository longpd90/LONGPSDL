//
//  PDServerPhotosSearch.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 17/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"

@interface PDServerPhotosSearch : PDServerExchange

- (void)searchPhotos:(NSString *)text page:(NSInteger) page;
- (void)searchPhotos:(NSString *)text page:(NSInteger)page latitude:(float)latitude longitude:(float)longitude;

@end
