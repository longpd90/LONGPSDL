//
//  PDServerPin.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 23/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"


@interface PDServerPin : PDServerExchange

- (void)pinPhoto:(PDPhoto *)photo;
- (void)unpinPhoto:(PDPhoto *)photo;

@end
