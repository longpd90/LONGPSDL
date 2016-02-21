//
//  PDServerPhotoUploader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "PDServerPhotoUploader.h"
#import "NSData+YBase64String.h"
#import "NSString+URLEncoding.h"
#import "PDPhotoUpload.h"

@interface PDServerPhotoUploader () <UIAlertViewDelegate>
@property (nonatomic, strong) PDPhotoUpload *photoUpload;
@property (nonatomic, strong) CLUploader *uploader;
- (NSString *)filepath;
- (void)uploadLastPhoto;
- (void)startUploadPhotoToServer;
- (void)showUploadProcessView;
- (void)uploadPhotoWithData:(NSString *)dataUpload;
@end

#define PDSuccessAlertViewTag		1
#define PDFailAlertViewTag          2

@implementation PDServerPhotoUploader
@synthesize queue;

static PDServerPhotoUploader *_instance;
+ (PDServerPhotoUploader *)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (void)startUploadQueue
{
	if (queue.count == 0 || self.serverPhotoUpload.isLoading || self.uploadResultAlertView) return;
	[kPDAppDelegate.uploadPhotoView reset];
	kPDAppDelegate.uploadPhotoView.hidden = NO;
	[self uploadLastPhoto];
}

- (void)startUploadPhotoToServer
{
    if (queue.count == 0 || self.serverPhotoUpload.isLoading || self.uploadResultAlertView) return;
    PDPhotoUpload *photoUpload = (PDPhotoUpload *)[queue lastObject];
    [self uploadPhotoWithData:[photoUpload getDataUpload]];
}

- (void)showUploadProcessView
{
    [kPDAppDelegate.uploadPhotoView reset];
    kPDAppDelegate.uploadPhotoView.hidden = NO;
    kPDAppDelegate.uploadPhotoView.progress = 0;
    kPDAppDelegate.uploadPhotoView.image = [[UIImage alloc] initWithData:_photoUpload.imageData];
}

- (void)uploadImageToCloudinary:(UIImage *)image
{
    NSLog(@"start upload process");
    if (_uploader) {
        [_uploader cancel];
        _uploader = nil;
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    if (!_photoUpload)
        self.photoUpload = [[PDPhotoUpload alloc] initWithImageData:imageData];
    
    CLCloudinary *cloudDinary = [[CLCloudinary alloc] initWithUrl:kPDCloudinaryURL];
    self.uploader = [[CLUploader alloc] init:cloudDinary delegate:self];
    [_uploader upload:imageData options:@{} withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
        if (successResult) {
            NSString *publicId = [successResult valueForKey:@"public_id"];
            int width = [successResult intForKey:@"width"];
            int height = [successResult intForKey:@"height"];
            [self.photoUpload setDataUploadWithPublicId:publicId width:width height:height];
            switch (_photoUpload.state) {
                case PDPhotoUploadStateCloudStartProcess:
                {
                    NSLog(@"cloud success, waiting upload");
                    _photoUpload.state = PDPhotoUploadStateCloudSuccessWaitingUpload;
                    break;
                }
                case PDPhotoUploadStateCloudInProcessAlreadyUpload:
                {
                    _photoUpload.state = PDPhotoUploadStateCloudSuccessAlreadyUpload;
                    NSLog(@"Cloud success, start upload");
                    [queue addObject:_photoUpload];
                    _photoUpload = nil;
                    [self startUploadPhotoToServer];
                    break;
                }
                case PDPhotoUploadStateCloudFailedAlreadyUpload:
                {
                    NSLog(@"cloud success, upload again");
                    _photoUpload.state = PDPhotoUploadStateCloudSuccessAlreadyUpload;
                    [self uploadPhotoWithData:[_photoUpload getDataUpload]];
                    break;
                }
                default:
                    break;
            }
        } else {
            switch (_photoUpload.state) {
                case PDPhotoUploadStateCloudStartProcess:
                {
                    NSLog(@"cloud failed, waiting upload");
                    _photoUpload.state = PDPhotoUploadStateCloudFailedWaitingUpload;
                    break;
                }
                case PDPhotoUploadStateCloudInProcessAlreadyUpload:
                {
                    _photoUpload.state = PDPhotoUploadStateCloudFailedAlreadyUpload;
                    [queue addObject:_photoUpload];
                    NSLog(@"cloud failed, show error");
                    [self showUploadFailed];
                    break;
                }
                case PDPhotoUploadStateCloudFailedAlreadyUpload:
                {
                    NSLog(@"cloud failed again, show error");
                    [self showUploadFailed];
                    break;
                }
                default:
                    break;
            }
        }
    } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
    }];
    
}

- (void)saveQueueToDisk
{
    if (![NSKeyedArchiver archiveRootObject:queue toFile:[[self filepath] stringByAppendingString:@"photo_upload"]]) {
        NSLog(@"Error writing queue to disk");
    }
}

- (void)loadQueueFromDisk
{
    queue = [NSKeyedUnarchiver unarchiveObjectWithFile:[[self filepath] stringByAppendingString:@"photo_upload"]];
    
	if (!queue) {
		queue = [NSMutableArray array];
	}
}

- (void)addItemToQueueWithPhoto:(PDPhoto *)photo
                       exifInfo:(NSDictionary *)metadata
                          poiId:(int)poiId
                  facebookShare:(BOOL)facebookShare
{
    [self.photoUpload setDataUloadWithPhoto:photo
                                   metadata:metadata poiId:poiId
                            isShareFacebook:facebookShare];
    switch (_photoUpload.state) {
        case PDPhotoUploadStateCloudStartProcess:
        {
            [self showUploadProcessView];
            _photoUpload.state = PDPhotoUploadStateCloudInProcessAlreadyUpload;
            NSLog(@"click upload, wait image_id from cloud");
            break;
        }
        case PDPhotoUploadStateCloudSuccessWaitingUpload:
        {
            _photoUpload.state = PDPhotoUploadStateCloudSuccessAlreadyUpload;
            [queue addObject:_photoUpload];
            self.photoUpload = nil;
            NSLog(@"have image_id, start upload");
            [self startUploadQueue];
            break;
        }
        case PDPhotoUploadStateCloudFailedWaitingUpload:
        {
            [self showUploadProcessView];
            NSLog(@"upload process failed, show error");
            _photoUpload.state = PDPhotoUploadStateCloudFailedAlreadyUpload;
            [queue addObject:_photoUpload];
            [self showUploadFailed];
            break;
        }
        default:
            break;
    }
}

- (void)cancelLastUpload
{
	if (queue.count == 0) return;
	[queue removeObject:queue.lastObject];
	[self saveQueueToDisk];
}

- (void)cancelUploadProcess
{
    [_uploader cancel];
    _uploader = nil;
    self.photoUpload = nil;
}

- (void)showUploadFailed
{
    [self saveQueueToDisk];
    self.photoUpload = nil;
    self.uploadResultAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Upload", nil)
                                                            message:NSLocalizedString(@"There was a problem with uploading photo!", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"Retry", nil), nil];
	self.uploadResultAlertView.tag = PDFailAlertViewTag;
	[self.uploadResultAlertView show];
	[UIView animateWithDuration:0.7 animations:^{
		kPDAppDelegate.uploadPhotoView.frame = CGRectMake((kPDAppDelegate.window.width - kPDAppDelegate.uploadPhotoView.width * 2) / 2,
														  kPDAppDelegate.uploadPhotoView.y * 2,
														  kPDAppDelegate.uploadPhotoView.width * 2,
														  kPDAppDelegate.uploadPhotoView.height * 2);
		kPDAppDelegate.uploadPhotoView.alpha = 1;
		
	}];
}

#pragma mark - Private

- (void)uploadPhotoWithData:(NSString *)dataUpload
{
    if (!self.serverPhotoUpload) {
        self.serverPhotoUpload = [[PDServerPhotoUpload alloc] initWithDelegate:self];
    }
    NSLog(@"upload last photo data: %@", dataUpload);
    [self.serverPhotoUpload uploadPhotoWithData:dataUpload];
}

- (void)uploadLastPhoto
{
    NSLog(@"retry upload photo");
	if (queue.count == 0 || self.serverPhotoUpload.isLoading || self.uploadResultAlertView) return;
    
	kPDAppDelegate.uploadPhotoView.progress = 0;
    self.photoUpload = [queue lastObject];
    kPDAppDelegate.uploadPhotoView.image = [[UIImage alloc] initWithData:_photoUpload.imageData];
    if (_photoUpload.state == PDPhotoUploadStateCloudFailedAlreadyUpload) {
        [self uploadImageToCloudinary:[[UIImage alloc] initWithData:_photoUpload.imageData]];
    } else {
        [self uploadPhotoWithData:[_photoUpload getDataUpload]];
    }
}

- (NSString *)filepath
{
	return [kPDLibraryPath stringByAppendingPathComponent:kPDPhotoUploadQueueFilename];
}

#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
    self.photoUpload = nil;
	[self cancelLastUpload];
    NSDictionary *dictionary = result[@"photo"];
    PDPhoto *photo = [[PDPhoto alloc] init];
    [photo loadShortDataFromDictionary:dictionary];
    [kPDUserDefaults setObject:[NSNumber numberWithInteger:photo.identifier] forKey:kPDPhotoUploadedIdKey];
	if (queue.count == 0) {
		self.uploadResultAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Upload", nil)
                                                                message:NSLocalizedString(@"Photo uploaded successfully", nil)
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
		self.uploadResultAlertView.tag = PDSuccessAlertViewTag;
		[self.uploadResultAlertView show];
		[UIView animateWithDuration:0.7 animations:^{
			kPDAppDelegate.uploadPhotoView.frame = CGRectMake((kPDAppDelegate.window.width - kPDAppDelegate.uploadPhotoView.width * 2) / 2,
															  kPDAppDelegate.uploadPhotoView.y * 2,
															  kPDAppDelegate.uploadPhotoView.width * 2,
															  kPDAppDelegate.uploadPhotoView.height * 2);
			kPDAppDelegate.uploadPhotoView.alpha = 1;
		}];
	} else {
		[self uploadLastPhoto];
	}
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
    [self showUploadFailed];
}


#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	self.uploadResultAlertView = nil;
	if (alertView.tag == PDSuccessAlertViewTag) {
		kPDAppDelegate.uploadPhotoView.hidden = YES;
	} else {
		if (buttonIndex == alertView.cancelButtonIndex) {
			[self cancelLastUpload];
			kPDAppDelegate.uploadPhotoView.hidden = YES;
		} else {
			[UIView animateWithDuration:1 animations:^{
				[kPDAppDelegate.uploadPhotoView reset];
			} completion:^(BOOL finished) {
				[self uploadLastPhoto];
			}];
		}
	}
}

@end
