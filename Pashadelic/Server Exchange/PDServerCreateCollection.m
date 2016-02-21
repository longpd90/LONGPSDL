//
//  PDServerCreateCollection.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.07.13.
//
//

#import "PDServerCreateCollection.h"

@implementation PDServerCreateCollection

- (void)createCollection:(PDPhotoCollection *)collection photo:(PDPhoto *)photo
{
	self.photo = photo;
	self.collection = collection;
	NSString *parameters = [NSString stringWithFormat:@"[photo_collection]name=%@&[photo_id]=%zd", collection.title, photo.identifier];
	self.functionPath = @"collections.json";
	[self requestToPostFunctionWithString:parameters];
}

@end
