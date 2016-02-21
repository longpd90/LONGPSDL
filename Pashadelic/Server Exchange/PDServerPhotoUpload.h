//
//  PDServerPhotoUpload.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 23/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"


@interface PDServerPhotoUpload : PDServerExchange

- (void)uploadPhotoWithData:(NSString *)data;
@end
