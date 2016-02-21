//
//  PDListCellHeader.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13/10/12.
//
//

#import <UIKit/UIKit.h>
#import "PDPhoto.h"

@interface PDListCellHeader : UIView
<PDItemImageLoaderDelegate>

@property (weak, nonatomic) PDPhoto *photo;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end
