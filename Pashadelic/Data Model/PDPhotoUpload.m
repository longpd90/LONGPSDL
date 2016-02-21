//
//  PDPhotoUpload.m
//  Pashadelic
//
//  Created by TungNT2 on 1/3/14.
//
//

#import "PDPhotoUpload.h"
#import "NSData+YBase64String.h"
#import "NSString+URLEncoding.h"
#import <ImageIO/ImageIO.h>

@interface PDPhotoUpload ()
@property (nonatomic, strong) NSString *dataUpload;
@end

@implementation PDPhotoUpload

#pragma mark - NSCoding delegate

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _imageData = [aDecoder decodeObjectForKey:@"image_data"];
        _dataUpload = [aDecoder decodeObjectForKey:@"data_upload"];
        _state = [aDecoder decodeIntForKey:@"state"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_imageData forKey:@"image_data"];
    [aCoder encodeObject:_dataUpload forKey:@"data_upload"];
    [aCoder encodeInt:_state forKey:@"state"];
}

- (id)initWithImageData:(NSData *)imageData
{
    self = [super init];
    if (self) {
        _imageData = imageData;
        _state = PDPhotoUploadStateCloudStartProcess;
    }
    return  self;
}

- (void)setDataUloadWithPhoto:(PDPhoto *)photo metadata:(NSDictionary *)metadata poiId:(int)poiId isShareFacebook:(BOOL)isShareFacebook
{
    NSMutableDictionary *EXIFInfo = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *TIFFInfo ;
	if ([metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary]) {
		EXIFInfo = [NSMutableDictionary dictionaryWithDictionary:
					[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary]];
	}
	if ([metadata objectForKey:(NSString *)kCGImagePropertyTIFFDictionary]) {
		TIFFInfo = [NSMutableDictionary dictionaryWithDictionary:
					[metadata objectForKey:(NSString *)kCGImagePropertyTIFFDictionary]];
	}
    
	if (![[EXIFInfo objectForKey:(NSString *)kCGImagePropertyExifDateTimeOriginal] dateFormattedByString:@"yyyy:MM:dd HH:mm:ss"]) {
        [EXIFInfo setObject:[[NSDate date] stringValueFormattedBy:@"yyyy:MM:dd HH:mm:ss"] forKey:(NSString *)kCGImagePropertyExifDateTimeOriginal];
	}
	NSString *facebookShareString = isShareFacebook ? @"true" : @"false";
	
	NSMutableString *request = [NSMutableString stringWithFormat:
                                @"photo[title]=%@&photo[description]=%@&photo[tag_list]=%@&photo[width]=%d&photo[height]=%d&photo[exif_attributes][aperture_value]=%@&photo[taken_on]=%@&photo[exif_attributes][focal_length]=%@&photo[exif_attributes][iso_speed_ratings]=%@&photo[exif_attributes][shutter_speed_value]=%@&lon=%f&lat=%f&photo[exif_attributes][camera_model]=%@&photo[exif_attributes][make]=%@&photo[poi_id]=%ld&[photo]fb_share=%@",
                                [photo.title urlEncodeUsingEncoding:NSUTF8StringEncoding] ? [photo.title urlEncodeUsingEncoding:NSUTF8StringEncoding] : @"",
                                [photo.details urlEncodeUsingEncoding:NSUTF8StringEncoding] ? [photo.details urlEncodeUsingEncoding:NSUTF8StringEncoding] : @"",
                                [photo.tags urlEncodeUsingEncoding:NSUTF8StringEncoding] ? [photo.tags urlEncodeUsingEncoding:NSUTF8StringEncoding] : @"",
                                photo.photoWidth,
                                photo.photoHeight,
                                [EXIFInfo objectForKey:@"FNumber"] ? [EXIFInfo objectForKey:@"FNumber"] : @"",
                                [EXIFInfo objectForKey:(NSString *)kCGImagePropertyExifDateTimeOriginal] ?  [EXIFInfo objectForKey:(NSString *)kCGImagePropertyExifDateTimeOriginal] : @"",
                                [EXIFInfo objectForKey:@"FocalLength"] ? [EXIFInfo objectForKey:@"FocalLength"] : @"",
                                [EXIFInfo objectForKey:@"ISOSpeedRatings"] ? [EXIFInfo objectForKey:@"ISOSpeedRatings"] : @"",
                                [EXIFInfo objectForKey:@"ExposureTime"] ? [EXIFInfo objectForKey:@"ExposureTime"] : @"",
                                photo.longitude,
                                photo.latitude,
                                [TIFFInfo objectForKey:@"Make"] ? [TIFFInfo objectForKey:@"Make"] : @"",
                                [TIFFInfo objectForKey:@"Model"] ? [TIFFInfo objectForKey:@"Model"] : @"",
                                (long)poiId,
                                facebookShareString];
    
	if (photo.tripod != kPDNoTip)
        [request appendFormat:@"&photo[tripod]=%ld", (long)photo.tripod];
    
    if (photo.is_crowded != kPDNoTip)
        [request appendFormat:@"&photo[is_crowded]=%ld", (long)photo.is_crowded];
    
	if (photo.is_parking != kPDNoTip)
        [request appendFormat:@"&photo[is_parking]=%ld", (long)photo.is_parking];
    
    if (photo.is_dangerous != kPDNoTip)
        [request appendFormat:@"&photo[is_dangerous]=%ld", (long)photo.is_dangerous];
    
    if (photo.indoor != kPDNoTip)
        [request appendFormat:@"&photo[indoor]=%ld", (long)photo.indoor];
    
    if (photo.is_permission != kPDNoTip)
        [request appendFormat:@"&photo[is_permission]=%ld", (long)photo.is_permission];
    
    if (photo.is_paid != kPDNoTip)
        [request appendFormat:@"&photo[is_paid]=%ld", (long)photo.is_paid];
    
    if (photo.difficulty_access != 0)
        [request appendFormat:@"&photo[difficulty]=%ld", (long)photo.difficulty_access];
    
    if (_dataUpload != nil && _dataUpload.length > 0) {
        self.dataUpload = [self.dataUpload stringByAppendingString:[NSString stringWithFormat:@"&%@", request]];
    } else {
        self.dataUpload = request;
    }
}

- (void)setDataUploadWithPublicId:(NSString *)publicId width:(int)width height:(int)height
{
    if (_dataUpload != nil && _dataUpload.length > 0)
        self.dataUpload = [self.dataUpload stringByAppendingString:[NSString stringWithFormat:@"&photo[image_id]=%@&photo[width]=%d&photo[height]=%d", publicId, width, height]];
    else
        self.dataUpload = [NSString stringWithFormat:@"photo[image_id]=%@&photo[width]=%d&photo[height]=%d", publicId, width, height];
}

#pragma mark - Private

- (NSString *)getDataUpload
{
    if (_state == PDPhotoUploadStateCloudSuccessAlreadyUpload) {
        return _dataUpload;
    } else {
        return nil;
    }
}

@end
