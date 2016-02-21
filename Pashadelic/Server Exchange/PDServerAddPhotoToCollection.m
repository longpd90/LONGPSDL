//
//  PDServerAddPhotoToCollection.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.07.13.
//
//

#import "PDServerAddPhotoToCollection.h"

@implementation PDServerAddPhotoToCollection

- (void)addPhoto:(PDPhoto *)photo toCollection:(PDPhotoCollection *)collection
{
	self.photo = photo;
	self.photoCollection = collection;
	self.functionPath = [NSString stringWithFormat:@"collections/%zd/add_remove_photo.json", collection.identifier];
	[self requestToPostFunctionWithString:[NSString stringWithFormat:@"photo_id=%zd", photo.identifier]];
}

@end
