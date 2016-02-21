//
//  PDPlanAnnotaionView.m
//  Pashadelic
//
//  Created by LongPD on 11/15/13.
//
//

#import "PDPlanAnnotaionView.h"

@implementation PDPlanAnnotaionView

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withImage:(UIImage *)image{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:@"bg-plan-map.png"];
        UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:backgroundImage];
        backgroundImageView.frame = CGRectMake(-23, -60, 46, 60);
        UIImageView *planImageView = [[UIImageView alloc]initWithImage:image];
        planImageView.frame = CGRectMake(-21, -58, 42, 42);
        [self addSubview:backgroundImageView];
        [self addSubview:planImageView];
	}
	return self;
}



@end
