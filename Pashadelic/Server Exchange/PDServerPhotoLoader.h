//
//  PDServerPhotoLoader.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"


@interface PDServerPhotoLoader : PDServerExchange
@property (strong, nonatomic) PDPhoto *photoItem;

- (void)loadPhotoItem:(PDPhoto *)photo;

@end
