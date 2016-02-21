//
//  MGViewController.m
//  Spaxtel
//
//  Created by Vitaliy Gozhenko on 18/10/12.
//
//

#import "MGViewController.h"
#import "UIView+Extra.h"
#import "AdditionalFunctions.h"

@interface MGViewController ()
@property (assign, nonatomic, readonly) BOOL systemVersionGreaterThan7;
@end

@implementation MGViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
    _systemVersionGreaterThan7 = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
	}
	return self;
}

- (id)initFromClassName
{
	self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
	return self;
}

- (id)initForUniversalDevice
{
	NSString *nibName = [[self class] nibName];
	if (![[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"]) {
		if (isPhone()) {
			nibName = [nibName stringByAppendingString:@"_iPhone"];
		} else {
			nibName = [nibName stringByAppendingString:@"_iPad"];
		}
	}
	self = [self initWithNibName:nibName bundle:nil];
	return self;
}

+ (NSString *)nibName
{
	return NSStringFromClass([self class]);
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	self.verticalControlScrollOffset = 20;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:self.view.window];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:self.view.window];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:self.view.window];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:self.view.window];
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewDidUnload];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Public

- (void)scrollToCurrentControl
{
	if (!self.contentScrollView || !self.currentControl) return;
	
	CGPoint controlPosition = [self.contentScrollView convertPoint:CGPointZero fromView:self.currentControl];
	NSUInteger scrollFrameHeight = self.contentScrollView.height - self.contentScrollView.contentInset.bottom;
	NSInteger yOffset = controlPosition.y - scrollFrameHeight + self.currentControl.height + self.verticalControlScrollOffset;
	
	[self.contentScrollView setContentOffset:CGPointMake(0, yOffset) animated:YES];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
	if (self.isKeyboardShown || !self.view.window) return;
	self.keyboardShown = YES;
	
	if (!self.contentScrollView) return;
	
	CGRect keyboardFrame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	double duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	

	
	[UIView animateWithDuration:duration animations:^{
		UIEdgeInsets contentInset = self.contentScrollView.contentInset;
		contentInset.bottom = keyboardFrame.size.height;
		self.contentScrollView.contentInset = contentInset;
		self.contentScrollView.scrollIndicatorInsets = contentInset;
		
	} completion:^(BOOL finished) {
		[self scrollToCurrentControl];
	}];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	if (!self.isKeyboardShown || !self.contentScrollView || !self.view.window) return;
	
	self.keyboardShown = NO;
  
	double duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	
	[UIView animateWithDuration:duration animations:^{
		UIEdgeInsets contentInset = self.contentScrollView.contentInset;
		contentInset.bottom = 0;
		self.contentScrollView.contentInset = contentInset;
		self.contentScrollView.scrollIndicatorInsets = contentInset;
	}];
}


#pragma mark - Text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	self.currentControl = textField;
	if (self.isKeyboardShown) {
		[self scrollToCurrentControl];
	}
	return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	self.currentControl = textView;
	if (self.isKeyboardShown) {
		[self scrollToCurrentControl];
	}
	return YES;
}



@end
