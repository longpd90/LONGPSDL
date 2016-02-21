//
//  PDServerAddPhotoToCollection.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.07.13.
//
//

#import "PDServerExchange.h"

#import "PDPhotoCollection.h"

@interface PDServerAddPhotoToCollection : PDServerExchange

@property (strong, nonatomic) PDPhoto *photo;
@property (strong, nonatomic) PDPhotoCollection *photoCollection;

- (void)addPhoto:(PDPhoto *)photo toCollection:(PDPhotoCollection *)collection;

@end
