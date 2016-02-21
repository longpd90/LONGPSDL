//
//  PDServerDeletePhoto.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"


@interface PDServerDeletePhoto : PDServerExchange

- (void)deletePhoto:(PDPhoto *)photo;

@end
