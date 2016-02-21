//
//  PDRecommendedUsersDescripstion.m
//  Pashadelic
//
//  Created by TungNT2 on 11/13/13.
//
//

#import "PDRecommendedUsersDescripstion.h"

@implementation PDRecommendedUsersDescripstion

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.descriptionLabel.text = NSLocalizedString(@"You will have more fun if you follow more people in Pashadelic.\n Don't worry. other users cannot see your followings \n Follow others once you see good photo-spot sharing by them", nil);
}

@end
