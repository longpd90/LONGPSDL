//
//  PDServerUserAvatarUpload.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"

@interface PDServerUserAvatarUpload : PDServerExchange

- (void)uploadAvatar:(UIImage *)image;

@end
