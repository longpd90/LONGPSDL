//
//  PDServerCreateCollection.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.07.13.
//
//

#import "PDServerExchange.h"
#import "PDPhotoCollection.h"

@interface PDServerCreateCollection : PDServerExchange
@property (strong, nonatomic) PDPhoto *photo;
@property (strong, nonatomic) PDPhotoCollection *collection;

- (void)createCollection:(PDPhotoCollection *)photoCollection photo:(PDPhoto *)photo;

@end
