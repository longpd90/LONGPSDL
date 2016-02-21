//
//  PDUserTableViewCell.m
//  Pashadelic
//
//  Created by LongPD on 8/18/14.
//
//

#import "PDUserTableViewCell.h"

@implementation PDUserTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.backgroundView = [[UIView alloc] initWithFrame:self.zeroPositionFrame];
		self.backgroundView.autoresizingMask = kFullAutoresizingMask;
		self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        int x = 0;
        int width = 25;
        int height = 25;
        
        NSMutableArray *views = [NSMutableArray array];

        for (int i = 0; i < 3; i++) {
            UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
            photoView.layer.cornerRadius = 4;
            photoView.layer.masksToBounds = YES;
            [views addObject:photoView];
            [self addSubview:photoView];
            x += width + 2;
        }
        _photoViews = views;
	}
	return self;
}

- (void)setUsers:(NSArray *)users
{
	_users = users;
	for (int i = 0; i < 3; i++) {        
		UIImageView *photoView = [_photoViews objectAtIndex:i];
        [photoView setImage:nil];

		if (i < _users.count) {
            PDUser *user = [_users objectAtIndex:i];
            [photoView sd_setImageWithURL:user.thumbnailURL
                 placeholderImage:[UIImage imageNamed:@"tile_shadow.png"]
                          options:SDWebImageRetryFailed
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
		} else {
			photoView = nil;
		}
	}
}

@end
