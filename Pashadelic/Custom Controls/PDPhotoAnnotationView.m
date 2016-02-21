//
//  PDPhotoAnnotationView.m
//  Pashadelic
//
//  Created by LongPD on 12/23/13.
//
//

#import "PDPhotoAnnotationView.h"
#import "KPAnnotation.h"

@implementation PDPhotoAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 44, 44)];
        [self addSubview:_photoImageView];
        self.image = [UIImage imageNamed:@"1-photo.png"];
        self.frame = CGRectMake(0, 0, 52, 52);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowRadius = 1;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
    }
    return self;
}

- (void)setPhoto:(PDPhoto *)newPhoto
{
    _photo = newPhoto;
    UIImage *placeHolderImage = [UIImage imageNamed:@"tile_shadow.png"];
    [_photoImageView sd_setImageWithURL:_photo.thumbnailURL placeholderImage:placeHolderImage completed:nil];
}

@end
