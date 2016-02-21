//
//  PDLandmarkAnnotationView.m
//  Pashadelic
//
//  Created by LongPD on 6/27/14.
//
//

#import "PDLandmarkAnnotationView.h"
#import "FontAwesomeKit.h"
#import "Globals.h"
#define FAKFontAwesomePhotoIcon   @"\uf03e"
#define FAKFontAwesomeUseIcon     @"\uf0c0"

@implementation PDLandmarkAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 110, 65)];
        [self addSubview:_photoImageView];
        
        _photoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, 80, 20)];
        [_photoCountLabel setFont:[UIFont fontWithName:PDGlobalNormalFontName size:14]];
        [_photoCountLabel setTextColor:kPDGlobalComfortColor];
        [self addSubview:_photoCountLabel];
        
        _userCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 70, 80, 20)];
        [_userCountLabel setFont:[UIFont fontWithName:PDGlobalNormalFontName size:14]];
        [_userCountLabel setTextColor:kPDGlobalComfortColor];
        [self addSubview:_userCountLabel];
        
        UIImageView *photoCountImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(5, 70, 20, 20)];
        UIImageView *userCountImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(65, 70, 20, 20)];
        float fontSize = 15;
        NSDictionary *comfortColorAttribute = @{NSForegroundColorAttributeName:kPDGlobalComfortColor};
        
        [photoCountImageView setFontAwesomeIconForImage:[FAKFontAwesome iconWithCode:FAKFontAwesomePhotoIcon size:fontSize]
                                      withAttributes:comfortColorAttribute ];
        [userCountImageView setFontAwesomeIconForImage:[FAKFontAwesome iconWithCode:FAKFontAwesomeUseIcon size:fontSize]
                                     withAttributes:comfortColorAttribute ];
        [self addSubview:photoCountImageView];
        [self addSubview:userCountImageView];
        
        self.image = [UIImage imageNamed:@"landmark-anotation.png"];
        self.frame = CGRectMake(0, 0, 120, 106);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowRadius = 1;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
        self.centerOffset = CGPointMake(0, - self.height / 2);

    }
    return self;
}

- (void)setLandmark:(PDPhotoLandMarkItem *)landmark
{
    _landmark = landmark;
    UIImage *placeHolderImage = [UIImage imageNamed:@"tile_shadow.png"];
    [_photoImageView sd_setImageWithURL:_landmark.avatarTileURL placeholderImage:placeHolderImage completed:nil];
    _photoCountLabel.text = [NSString stringWithFormat:@"%d",landmark.photoCount];
    _userCountLabel.text = [NSString stringWithFormat:@"%d",landmark.userCount];
}

@end
