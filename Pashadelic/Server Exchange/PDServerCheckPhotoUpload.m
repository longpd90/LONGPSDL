//
//  PDServerCheckPhotoUpload.m
//  Pashadelic
//
//  Created by TungNT2 on 1/7/14.
//
//

#import "PDServerCheckPhotoUpload.h"

@implementation PDServerCheckPhotoUpload

- (void)checkPhotoUpload:(PDPhoto *)photo
{
    self.functionPath = [NSString stringWithFormat:@"photos/%d/check_upload_completed.json", photo.identifier];
    [self requestToGetFunctionWithString:nil];
}

@end
