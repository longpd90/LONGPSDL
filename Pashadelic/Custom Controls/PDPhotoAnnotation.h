//
//  PDPhotoAnnotation.h
//  Pashadelic
//
//  Created by LongPD on 12/23/13.
//
//

#import <Foundation/Foundation.h>

@interface PDPhotoAnnotation : NSObject<MKAnnotation>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D coordinate;
@property (weak, nonatomic) PDPhoto *photo;
- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;
@end
