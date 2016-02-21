//
//  PDPhotosScrollView.h
//  Pashadelic
//
//  Created by TungNT2 on 6/19/14.
//
//

#import <UIKit/UIKit.h>

@protocol PDPhotoScrollViewDelegate <NSObject>
- (void)refreshOwnerUserForPhoto:(PDPhoto *)photo;
@end

@interface PDPhotosScrollView : UIScrollView

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *photos;
@property (weak, nonatomic) id <PDPhotoViewDelegate> photoViewDelegate;
@property (weak, nonatomic) id <PDPhotoScrollViewDelegate> scrollViewDelegate;

- (void)changePage:(NSUInteger)page;
- (void)refreshScrollView;

@end
