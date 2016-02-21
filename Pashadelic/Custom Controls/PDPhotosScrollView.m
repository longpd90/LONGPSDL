//
//  PDPhotosScrollView.m
//  Pashadelic
//
//  Created by TungNT2 on 6/19/14.
//
//

#import "PDPhotosScrollView.h"

@implementation PDPhotosScrollView

- (void)awakeFromNib
{
    self.pageControl.hidesForSinglePage = YES;
}

- (void)refreshScrollView
{
    if (self.photos.count == 0) return;
    
    self.pageControl.numberOfPages = self.photos.count;
    self.pageControl.currentPage = 0;
    if (self.scrollViewDelegate && [self.scrollViewDelegate respondsToSelector:@selector(refreshOwnerUserForPhoto:)]) {
        [self.scrollViewDelegate refreshOwnerUserForPhoto:self.photos[self.pageControl.currentPage]];
    }
    for (int i = 0; i < [self.photos count]; i++) {
        PDPhoto *photo = (PDPhoto *)self.photos[i];
        CGRect frame;
        frame.origin.x = self.width * i;
        frame.origin.y = 0;
        frame.size = CGSizeMake(self.width, self.height);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.tag = i;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:photo.fullImageURL placeholderImage:[UIImage imageNamed:@"tile_shadow.png"]];
        [self addSubview:imageView];
    }
    self.contentSize = CGSizeMake(self.width * self.photos.count, self.height);
}

- (void)changePage:(NSUInteger)page
{
    if (page != self.pageControl.currentPage && page <= self.pageControl.numberOfPages) {
        self.pageControl.currentPage = page;
        PDPhoto *photo = (PDPhoto*)self.photos[self.pageControl.currentPage];
        if (!photo) return;
        if (self.scrollViewDelegate && [self.scrollViewDelegate respondsToSelector:@selector(refreshOwnerUserForPhoto:)]) {
            [self.scrollViewDelegate refreshOwnerUserForPhoto:photo];
        }
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.width;
    int page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page != self.pageControl.currentPage && page < self.photos.count) {
        self.pageControl.currentPage = page;
        PDPhoto *photo = (PDPhoto*)self.photos[self.pageControl.currentPage];
        if (!photo) return;
        if (self.scrollViewDelegate && [self.scrollViewDelegate respondsToSelector:@selector(refreshOwnerUserForPhoto:)]) {
            [self.scrollViewDelegate refreshOwnerUserForPhoto:photo];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.photos.count == 0) {
        return;
    }
    if (self.photoViewDelegate && [self.photoViewDelegate respondsToSelector:@selector(photo:didSelectInView:image:)]) {
        PDPhoto *photo = (PDPhoto *)self.photos[self.pageControl.currentPage];
        UIImageView *currentImageView = (UIImageView *)[self viewWithTag:self.pageControl.currentPage];
        if (!photo) return;
        [self.photoViewDelegate photo:photo didSelectInView:currentImageView image:photo.image];
    }
}

@end
