//
//  PDPhotoUpload.h
//  Pashadelic
//
//  Created by TungNT2 on 1/3/14.
//
//

#import <Foundation/Foundation.h>
@class PDPhoto;

enum {
    PDPhotoUploadStateCloudStartProcess = 0,
    PDPhotoUploadStateCloudInProcessAlreadyUpload,
    PDPhotoUploadStateCloudSuccessWaitingUpload,
    PDPhotoUploadStateCloudFailedWaitingUpload,
    PDPhotoUploadStateCloudSuccessAlreadyUpload,
    PDPhotoUploadStateCloudFailedAlreadyUpload
} typedef PDPhotoUploadState;

@interface PDPhotoUpload : NSObject <NSCoding>
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, assign) PDPhotoUploadState state;
- (id)initWithImageData:(NSData *)imageData;
- (void)setDataUloadWithPhoto:(PDPhoto *)photo
                     metadata:(NSDictionary *)metadata
                        poiId:(int)poiId
              isShareFacebook:(BOOL)isShareFacebook;
- (void)setDataUploadWithPublicId:(NSString *)publicId width:(int)width height:(int)height;
- (NSString *)getDataUpload;
@end
