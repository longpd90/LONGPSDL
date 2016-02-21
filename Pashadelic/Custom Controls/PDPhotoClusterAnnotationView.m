//
//  PDPhotoClusterAnnotationView.m
//  Pashadelic
//
//  Created by LongPD on 12/27/13.
//
//

#import "PDPhotoClusterAnnotationView.h"
#import "KPAnnotation.h"
#import <QuartzCore/QuartzCore.h>

@implementation PDPhotoClusterAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 44, 44)];
        [self addSubview:_photoImageView];
        self.numberPhotosLabel = [[PDDynamicFontLabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        self.numberPhotosLabel.textColor = [UIColor whiteColor];
        self.numberPhotosLabel.font = [UIFont fontWithName:PDGlobalBoldFontName size:14];
        self.numberPhotosLabel.clipsToBounds = YES;
        self.numberPhotosLabel.layer.cornerRadius = 13;
        self.numberPhotosLabel.textAlignment = NSTextAlignmentCenter;
        self.numberPhotosLabel.backgroundColor = [UIColor colorWithRed:(255.0 / 255.0)
                                                                 green:(95 / 255.0)
                                                                  blue:(42 / 255.0)
                                                                 alpha:1.0];
        [self addSubview:_numberPhotosLabel];
        self.frame = CGRectMake(0, 0, 58, 58);
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

- (void)setCount:(NSInteger)newCount
{
    _count = newCount;
    if (newCount > 2) {
        [self setImage:[UIImage imageNamed:@"3-photo.png"]];
    } else{
        [self setImage:[UIImage imageNamed:@"2-photo.png"]];
    }
    self.numberPhotosLabel.text = [@(_count) stringValue];
}

@end
