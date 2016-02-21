
#import "PDPhotoLocationView.h"

@implementation PDPhotoLocationView
@synthesize photo;

- (NSString *)reuseIdentifier
{
	return NSStringFromClass([self class]);
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self) {
		self.canShowCallout = YES;
		self.image = [UIImage imageNamed:@"icon-map-camera-pin.png"];
		self.centerOffset = CGPointMake(0, -round(self.image.size.height / 2));
	}
    return self;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	if (!selected) {
		[super setSelected:selected animated:animated];
		return;
	}
	
	if (!_calloutViewButton) {
		[self initCalloutControls];
	}
	
	[self loadPhotoInfo];
	[super setSelected:selected animated:animated];
}

- (void)photoDidSelected:(id)sender
{
	if (self.photoViewDelegate) {
		[self.photoViewDelegate photo:photo didSelectInView:_thumbnailImage image:_thumbnailImage.image];
	} else {
		[photo itemWasSelected];
	}
}

- (void)loadPhotoInfo
{
	if (!photo) return;
	
	[_calloutViewButton addTarget:self action:@selector(photoDidSelected:) forControlEvents:UIControlEventTouchUpInside];
	int width = [photo.title sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].width;
	width = MAX(_pinsButton.rightXPoint, width);
	width = MIN(250 - _thumbnailImage.rightXPoint + 10, width);
	_calloutViewButton.width = width + _likesButton.x;
	
	self.thumbnailImage.image = nil;
	[self.thumbnailImage sd_setImageWithURL:self.photo.thumbnailURL];
	
	[_likesButton setTitle:photo.likesCountInString forState:UIControlStateNormal];
	[_pinsButton setTitle:photo.pinsCountInString forState:UIControlStateNormal];
	_titleLabel.text = photo.title;
}

- (void)initCalloutControls
{
	_calloutViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 32)];
	_calloutViewButton.clipsToBounds = NO;
	_thumbnailImage = [[PDImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
	_thumbnailImage.contentMode = UIViewContentModeScaleAspectFit;
	[_calloutViewButton addSubview:_thumbnailImage];
	
	int width = 40;
	int padding = 5;
	_likesButton = [[UIButton alloc] initWithFrame:CGRectMake(_thumbnailImage.rightXPoint + padding, 0, width, 18)];
	_likesButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	_likesButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	_likesButton.titleLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:15];
	[_likesButton setImage:[UIImage imageNamed:@"icon-like.png"] forState:UIControlStateNormal];
	_likesButton.userInteractionEnabled = NO;
	[_calloutViewButton addSubview:_likesButton];

	_pinsButton = [[UIButton alloc] initWithFrame:CGRectMake(_likesButton.rightXPoint + padding, 0, width, 18)];
	_pinsButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	_pinsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	_likesButton.titleLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:15];
	[_pinsButton setImage:[UIImage imageNamed:@"icon-wannago.png"] forState:UIControlStateNormal];
	_pinsButton.userInteractionEnabled = NO;
	[_calloutViewButton addSubview:_pinsButton];
	
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_thumbnailImage.rightXPoint + padding, _likesButton.bottomYPoint, _calloutViewButton.width - _thumbnailImage.rightXPoint + 10, 15)];
	[_titleLabel clearBackgroundColor];
	_titleLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:13];
	_titleLabel.textColor = [UIColor lightGrayColor];
	_titleLabel.clipsToBounds = NO;
	[_calloutViewButton addSubview:_titleLabel];
	self.leftCalloutAccessoryView = _calloutViewButton;
}

@end
