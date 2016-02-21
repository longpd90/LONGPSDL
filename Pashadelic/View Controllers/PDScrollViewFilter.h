//
//  PDScorllViewFilter.h
//  Pashadelic
//
//  Created by Duc Long on 7/1/13.
//
//

#import <UIKit/UIKit.h>
#import "PDImageFiltration.h"


@interface PDScrollViewFilter : UIScrollView <ImageFiltrationDelegate>
{
    UIImage *miniImage;
    NSMutableArray *filteredImages;
    NSOperationQueue *filterQueue;
    BOOL startedFilterRealImg;
    NSArray *arrayFilterName;
}
@property (nonatomic, retain) NSMutableArray *arrayImageFilter;
@property (retain, nonatomic) UIImage *miniImage;
@property (copy, nonatomic) NSMutableArray *filteredImages;
@property (retain, nonatomic) NSOperationQueue *filterQueue;

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image;

@end

