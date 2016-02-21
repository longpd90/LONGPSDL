//
//  PDServerPhotoUploader.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDServerPhotoUpload.h"
#import "Cloudinary.h"

@interface PDServerPhotoUploader : NSObject
<MGServerExchangeDelegate, CLUploaderDelegate>

@property (strong, nonatomic) NSMutableArray *queue;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) PDServerPhotoUpload *serverPhotoUpload;
@property (strong, nonatomic) UIAlertView *uploadResultAlertView;

+ (PDServerPhotoUploader *)sharedInstance;
- (void)cancelLastUpload;
- (void)startUploadQueue;
- (void)saveQueueToDisk;
- (void)loadQueueFromDisk;
- (void)addItemToQueueWithPhoto:(PDPhoto *)photo
                       exifInfo:(NSDictionary *)metadata
                          poiId:(int)poiId
                  facebookShare:(BOOL)facebookShare;
- (void)uploadImageToCloudinary:(UIImage *)image;
- (void)cancelUploadProcess;
- (void)showUploadFailed;
@end
