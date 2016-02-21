//
//  PDPlanCommentsViewController.h
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/20/14.
//
//

#import "PDCommentsViewController.h"
#import "PDPlan.h"


@interface PDPlanCommentsViewController : PDCommentsViewController

@property (strong, nonatomic) PDPlan *plan;

@property (strong, nonatomic) PDCommentsTableView *commentsTableView;

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;
@property (strong, nonatomic) IBOutlet UIView *addCommentView;
@property (weak, nonatomic) IBOutlet SSTextView *commentTextView;
@property (weak, nonatomic) IBOutlet PDGradientButton *sendButton;

- (IBAction)sentComment:(id)sender;


@end
