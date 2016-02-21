//
//  PDListCellHeader.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13/10/12.
//
//

@implementation PDListCellHeader

- (id)init
{
    self = [UIView loadFromNibNamed:@"PDListCellHeader"];
    if (self) {
        
    }
    return self;
}

- (void)setPhoto:(PDPhoto *)photo
{
	_photo = photo;
	
	_avatarImageView.image = nil;
	photo.user.delegate = self;
	[photo.user loadThumbnailInBackground];
    
	//title needs to move to the body
	_usernameLabel.text = photo.user.name;
}

- (void)imageDidLoad:(UIImage *)image item:(PDItem *)item
{
	if ([item isEqual:_photo.user]) {
		_avatarImageView.image = image;
	}
}

@end
