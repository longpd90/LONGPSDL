//
//  PDServerUserPhotoMapLoader.m
//  Pashadelic
//
//  Created by LongPD on 12/20/13.
//
//

#import "PDServerUserPhotoMapLoader.h"
#import "PDLocationHelper.h"

#define kPDRadius        20000.0
#define kPDMaxPhoto      500

@implementation PDServerUserPhotoMapLoader

- (void)loadPhotoOfUser:(PDUser *)user
{
	self.functionPath = [NSString stringWithFormat:@"search.json?query=*&lat=%f&lon=%f&range=%f&user_id=%zd&map=true&sort=distance&per=%zd",
                         [[PDLocationHelper sharedInstance] latitudes],
                         [[PDLocationHelper sharedInstance] longitudes] ,
                         kPDRadius,
                         user.identifier,
                         kPDMaxPhoto];
	[self requestToGetFunctionWithString:nil];
}

@end
