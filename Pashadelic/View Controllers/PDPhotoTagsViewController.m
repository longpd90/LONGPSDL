//  PDTagsViewController.m
//  Pashadelic
//
//  Created by Linh on 2/6/13.
//
//

#import "PDPhotoTagsViewController.h"
#import "PDCommentCell.h"

@interface PDPhotoTagsViewController ()

- (void)addTagWithString:(NSString *)tagName;
- (void)removeTagAtIndex:(NSUInteger)index;
- (BOOL)validateTextTags:(NSString *)textTag;
- (void)saveCurrentTags;
- (void)searchSuggestionTags;
- (NSArray *)parseSuggestionTagsFromTagList:(NSArray *)tagList;
- (void)showSearchSuggestions;
- (void)buttonAddTagDidClick;

@end

#define kPDTitleTagsLabelHeight             36
#define kPDTagsCellHeight                   36

@implementation PDPhotoTagsViewController

@synthesize tagsTableView;
@synthesize suggestionsTagsView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    self.title = NSLocalizedString(@"Add tags", nil);
    [self initTagsTextSearch];
    self.isSearching = NO;
    [self initSuggesttionTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchSuggestionTags)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.tagsTextField];
    _tags = [[NSMutableArray alloc] init];
    if (self.photo)
        [self setPhoto:self.photo];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.suggestionsTagsView = nil;
	self.serverSearchSuggestionTags = nil;
	self.tags = nil;
	self.tagsTextField = nil;
	self.tagsTableView = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self refreshView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

# pragma mark - private

- (void)initTagsTextSearch
{
    UIButton *addTagButton = [UIButton buttonWithImage:[UIImage imageNamed:@"btn_plus.png"]];
    self.tagsTextField.rightView = addTagButton;
    self.tagsTextField.rightView.hidden = YES;
    [self.tagsTextField setFont:[UIFont fontWithName:PDGlobalNormalFontName size:14]];
    [addTagButton addTarget:self
                     action:@selector(buttonAddTagDidClick)
           forControlEvents:UIControlEventTouchUpInside];
    self.tagsTextField.placeholder = NSLocalizedString(@"Start typing the tags name...", nil) ;
    [self.tagsTextField uploadPhotoStyle];
}

- (void)initSuggesttionTableView
{
    self.suggestionsTagsView = [[PDTagSuggestionView alloc] init];
	self.suggestionsTagsView.hidden = YES;
	self.suggestionsTagsView.delegate = self;
	[self.view addSubview:self.suggestionsTagsView];
}

- (BOOL)validateTextTags:(NSString *)textTag
{
    NSCharacterSet * characterSet = [NSCharacterSet characterSetWithCharactersInString:@"~!@#$%^[]|{}&*()_+=-/?\\⁄€‹›ﬂ‡°·‚—ºª•¶§∞¢£™¡`"];
    if ([textTag rangeOfCharacterFromSet:characterSet].location != NSNotFound) {
        [UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Prohibit any special characters", nil)];
        return NO;
    } else
        return YES;
}

- (void)setPhoto:(PDPhoto *)photo
{
    _photo = photo;
    if ([self isViewLoaded]) {
        _backgroudImageView.image = photo.image;
        [self.view sendSubviewToBack:self.backgroudImageView];
    }
}

- (void)goBack:(id)sender
{
    [self finish:nil];
}

- (void)refreshView
{
    if (_photo.tags.length <= 0) {
        return;
    }
    _tags = [NSMutableArray arrayWithArray:[_photo.tags componentsSeparatedByString:@", "]];
    if (_tags.count >0) {
        [tagsTableView reloadData];
    }
    
    [self resetView];
}

- (void)resetView
{
    if (_tags.count > 3) {
        self.tagsTableView.height = kPDTagsCellHeight * 3;
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.tags count] - 1) inSection:0];
        [self.tagsTableView scrollToRowAtIndexPath:scrollIndexPath
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:YES];
    } else
        self.tagsTableView.height =  kPDTagsCellHeight * _tags.count;
        
    self.tagsTextField.y = 3 + self.tagsTableView.bottomYPoint;
    self.tagsTableView.hidden = NO;
    self.tagsTextField.text = nil;
    self.suggestionsTagsView.hidden = YES;
    self.tagsTextField.hidden = NO;
    [self.tagsTextField becomeFirstResponder];
}

- (NSString *)pageName
{
	return @"Edit Upload Tags";
}

- (void)finish:(id)sender
{
	[self.currentControl performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0.5];
	
    if (_tags.count > 0)
        _photo.tags = [_tags componentsJoinedByString:@", "];
    else
        _photo.tags = nil;

	[self.navigationController popViewControllerRetro];
}

- (void)buttonAddTagDidClick
{
    [self addTagWithString:self.tagsTextField.text];
}

- (void)addTagWithString:(NSString *)tagName
{
    NSString *tag = [tagName stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (tag.length == 0) {
        return;
    }
    
    if ([_tags containsObject:tagName]) {
        [UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Tag already exist!", nil)];
        return;
    } else {
        self.tagsTextField.rightView.hidden = YES;
        [_tags addObject:tagName];
        [self.tagsTableView reloadData];
        [self resetView];
    }
}

- (void)showSearchSuggestions
{
    self.suggestionsTagsView.y = self.tagsTextField.bottomYPoint + 3;
    self.suggestionsTagsView.height = self.view.height - self.tagsTextField.bottomYPoint;
	self.suggestionsTagsView.hidden = NO;
}

- (void)removeTagAtIndex:(NSUInteger)index
{
    [self.tagsTextField resignFirstResponder];
	[_tags removeObjectAtIndex:index];

    if (_tags.count < 9) {
        self.tagsTableView.height =  kPDTagsCellHeight * _tags.count;
    } else
    {
        self.tagsTableView.height =  kPDTagsCellHeight * 9;
    }
    self.tagsTextField.y =  3 + self.tagsTableView.bottomYPoint;
        [self.tagsTableView reloadData];
	if (index >= _tags.count) {
    if (_tags.count == 0) {
        self.tagsTableView .hidden = YES;
    } else {
        self.tagsTableView.hidden = NO;
		}
	}
}

- (void)saveCurrentTags
{
    for (int i = 0; i < [_tags count]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        PDPhotoTagCell *cell = (PDPhotoTagCell *)[tagsTableView cellForRowAtIndexPath:indexPath];
        if (cell.tagNameLabel.text != nil && cell.tagNameLabel.text.length > 0) {
            [_tags setObject:cell.tagNameLabel.text atIndexedSubscript:i];
        }
        else {
            [_tags setObject:@"" atIndexedSubscript:i];
        }
    }
}

- (void)searchSuggestionTags
{
    self.serverSearchSuggestionTags.delegate = nil;
    self.serverSearchSuggestionTags = nil;
    if (self.tagsTextField.text.length == 0) {
        self.suggestionsTagsView.hidden = YES;
    }
    else {
        self.serverSearchSuggestionTags = [[PDServerSearchSuggestions alloc] initWithDelegate:self];
        [self.serverSearchSuggestionTags searchSuggestionsTags:self.tagsTextField.text];
    }
    
    if (self.tagsTextField.text.length > 0) {
        self.tagsTextField.rightView.hidden = NO;
    } else {
        self.tagsTextField.rightView.hidden = YES;
    }
}

- (NSArray *)parseSuggestionTagsFromTagList:(NSArray *)tagList
{
    NSMutableArray *suggestionTags = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < tagList.count; i++) {
        [suggestionTags addObject:[[tagList objectAtIndex:i] objectForKey:@"name"]];
    }
    return [[NSArray alloc] initWithArray:suggestionTags];
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tags.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPDTagsCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *TagCellIdentifier = @"PDPhotoTagCell";
	PDPhotoTagCell *cell = (PDPhotoTagCell *)[tableView dequeueReusableCellWithIdentifier:TagCellIdentifier];
	if (!cell) {
		cell = [UIView loadFromNibNamed:TagCellIdentifier];
        cell.delegate = self;
	}
    [cell setContentForCell:[_tags objectAtIndex:indexPath.row]];
	return cell;
}

#pragma mark - SearchSuggestionView delegate

- (void)didSrollTableView
{
    [self.tagsTextField resignFirstResponder];
    if (_tags.count > 3) {
        self.tagsTableView.height =  kPDTagsCellHeight * 3;
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.tags count] - 1) inSection:0];
        [self.tagsTableView scrollToRowAtIndexPath:scrollIndexPath
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:YES];
    } else
        self.tagsTableView.height = kPDTagsCellHeight * _tags.count;
    
    self.tagsTextField.y =  3 + self.tagsTableView.bottomYPoint;
}

- (void)searchSuggestionDidSelect:(NSString *)suggestion
{
    if ([_tags containsObject:suggestion]) {
        [UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Tag already exist!", nil)];
    } else
        [self addTagWithString:suggestion];
}

#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
    if (serverExchange == self.serverSearchSuggestionTags) {
        NSArray *suggestionTags = [self parseSuggestionTagsFromTagList:[result objectForKey:@"tag_list"]];
        if (suggestionTags.count > 0) {
            self.suggestionsTagsView.suggestions = suggestionTags;
            [self.suggestionsTagsView reloadData];
            if (self.isSearching == YES) {
                self.isSearching = NO;
            } else {
                if (self.suggestionsTagsView.isHidden ) {
                    [self showSearchSuggestions];
                }
            }
        } else {
			self.suggestionsTagsView.hidden = YES;
		}
    }
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
    if (serverExchange == self.serverSearchSuggestionTags) {
        if (!self.suggestionsTagsView.hidden) {
			self.suggestionsTagsView.hidden = YES;
        }
    }
}

#pragma mark - PDTagCell delegate

- (void)tagCellAction:(PDPhotoTagCell *)cell
{
	self.suggestionsTagsView.hidden = YES;
	NSIndexPath *indexPath = [tagsTableView indexPathForCell:cell];
    [self removeTagAtIndex:indexPath.row];
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.isSearching = YES;
    [self buttonAddTagDidClick];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_tags.count < 9) {
        self.tagsTableView.height = kPDTagsCellHeight * _tags.count;
    } else {
        self.tagsTableView.height =  kPDTagsCellHeight * 9;
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.tags count] - 1) inSection:0];
        [self.tagsTableView scrollToRowAtIndexPath:scrollIndexPath
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:YES];
    }
    self.tagsTextField.y =  3 + self.tagsTableView.bottomYPoint;
}

- (void)textFieldDidBeginEditing:(UITextView *)textView
{
    [self resetView];
}

#pragma mark - UITouch delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.tagsTextField resignFirstResponder];
}

@end
