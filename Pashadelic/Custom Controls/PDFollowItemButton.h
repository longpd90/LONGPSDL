//
//  PDFollowUserButton.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 18.11.12.
//
//

#import <UIKit/UIKit.h>
#import "PDServerFollowItem.h"

@interface PDFollowItemButton : UIButton
<MGServerExchangeDelegate>
{
	PDServerFollowItem *serverFollowItem;
}
@property (weak, nonatomic) PDItem *item;

- (void)initialize;
- (void)followButtonTouch;
- (void)refreshButton;
@end
