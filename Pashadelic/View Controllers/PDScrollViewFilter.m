//
//  PDScorllViewFilter.m
//  Pashadelic
//
//  Created by Duc Long on 7/1/13.
//
//

#import "PDScrollViewFilter.h"
#import "UIImage+Resize.h"
#define kSizeOfMiniImg 60
#define kPDScrollViewWidth  1280
#define kPDThumbnailFilterWidth 80

@interface PDScrollViewFilter (Private)
- (void)startImageFiltrationForImage:(UIImage *)thumbnailImage atIndex:(NSInteger)index;
@end

@implementation PDScrollViewFilter
@synthesize filteredImages, filterQueue, miniImage;

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.arrayImageFilter = [[NSMutableArray alloc]init];
        arrayFilterName = [[NSArray alloc] initWithObjects:@"No Filter", @"Vibrant", @"Beauty", @"XPro-mt",
                                                           @"Lomo-mt", @"Retro", @"Griseous", @"Sunrise",
                                                           @"Nostalgia", @"Chrome", @"Brownish", @"Happy",
                                                           @"Bright", @"Ink-wash", @"Instant", @"Richtone", nil];

        self.backgroundColor = [UIColor darkGrayColor];
        filterQueue = [NSOperationQueue new];
        [filterQueue setMaxConcurrentOperationCount:3];
        filteredImages = [[NSMutableArray alloc] init];
        
        miniImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                        bounds:CGSizeMake(kSizeOfMiniImg, kSizeOfMiniImg)
                                          interpolationQuality:kCGInterpolationDefault];
        for (int i=0; i<16; i++) {
            UIImage *tempImg = image;
            [filteredImages addObject:@[tempImg, @"NO"]];
            [self startImageFiltrationForImage:miniImage atIndex:i];
        }
        self.contentSize = CGSizeMake(kPDScrollViewWidth, kPDThumbnailFilterWidth);

    }
    return self;
}

- (void)startImageFiltrationForImage:(UIImage *)thumbnailImage atIndex:(NSInteger)index {
    if ([(NSString *)filteredImages[index][1] isEqualToString:@"YES"])
    {
        return;
    }
    PDImageFiltration *imageFiltration = [[PDImageFiltration alloc] initWithImage:thumbnailImage atIndex:index];
    imageFiltration.delegate = self;
    [filterQueue addOperation:imageFiltration];
}

- (void)imageFiltrationDidFinish:(PDImageFiltration *)filtration {
    CGFloat xOrigin = filtration.index * kPDThumbnailFilterWidth + 5;
    
    UIImageView *thumbnailFilteredImageView = [[UIImageView alloc] initWithImage:filtration.image];
    [thumbnailFilteredImageView setContentMode:UIViewContentModeScaleAspectFill];
    thumbnailFilteredImageView.clipsToBounds = YES;
    [thumbnailFilteredImageView setBackgroundColor:[UIColor blackColor]];

    [thumbnailFilteredImageView setFrame:CGRectMake(xOrigin, 20, kSizeOfMiniImg, kSizeOfMiniImg)];
    [self addSubview:thumbnailFilteredImageView];
    [self sendSubviewToBack:thumbnailFilteredImageView];
    [self.arrayImageFilter addObject:thumbnailFilteredImageView];
    
    
    UILabel *labelFilter = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 0, 60, 20)];
    [labelFilter setBackgroundColor:[UIColor clearColor]];
    [labelFilter setFont:[UIFont fontWithName:PDGlobalBoldFontName size:12]];
    [labelFilter setTextAlignment:NSTextAlignmentCenter];
    [labelFilter setTextColor:[UIColor whiteColor]];
    [labelFilter setText:[arrayFilterName objectAtIndex:filtration.index]];
    [self addSubview:labelFilter];
}

@end
