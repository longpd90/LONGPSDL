//
//  FTImageView.h
//  Pashadelic
//
//  Created by TungNT2 on 1/30/13.
//
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "Globals.h"
#import <dispatch/dispatch.h>
@class FTLayerView;
@class MTFinger;
@class MTTiltShift;

#define radiusLayerDefault 80.0f

@interface FTImageView : UIImageView

@property(nonatomic,retain) FTLayerView *ftLayerView;
@property(nonatomic,retain) MTTiltShift *mtTiltShift;
@property(nonatomic,retain) MTFinger *mtFinger;
@property(nonatomic,retain) UIImage *imageOrigin;
@property(nonatomic,retain) UIImage *imageFilter;
@property(nonatomic,retain) UIImage *imageTiltShift;
@property(nonatomic,retain) NSMutableDictionary *filtersBuffer;
@property(assign) NSInteger filterMode;
@property(assign) CGRect frameImageAspectFit;
@property(assign) CGSize sizeImageOrigin;
@property(assign) CGPoint centerLayerPoint;
@property(assign) CGPoint currentLayerP1, currentLayerP2;
@property(assign) CGPoint currentTiltP1, currentTiltP2;
@property(assign) CGFloat radiusLayer;
@property(assign) BOOL isCanActive;
@property(assign) BOOL isRound;

- (void)setImageInput:(UIImage*)image;
- (void)changeFilterMode:(PDImageFilterMode)filtersMode;
- (void)filteredImageAtIndex:(NSInteger)filterCase;
- (void)rotateImage;
- (void)clearFiltersBuffer;
@end
