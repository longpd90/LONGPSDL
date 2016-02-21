//
//  FTImageView.m
//  Pashadelic
//
//  Created by TungNT2 on 1/30/13.
//
//

#import "FTImageView.h"
#import "FTLayerView.h"
#import "MTFinger.h"
#import "MTTiltShift.h"
#import "UIImage+Rotate.h"

@interface FTImageView (Private)
- (CGPoint)pointImageScaleAspectFitFromImageViewPoint:(CGPoint)point;
- (CGPoint)pointImageOriginFromImageScaleAspectFitPoint:(CGPoint)point;
- (CGRect)imageFrameScaleAspectFit:(UIImageView *)imageView;
- (void)fingerImageWithTouchPoint:(CGPoint)touchPoint;
- (UIImage *)filteredImageWithImage:(UIImage *)image filter:(NSInteger)filterCase;
- (void)initLayerViewWithFrame:(CGRect)frame;
- (void)initFrameAndLayerForImage:(UIImage *)image;
- (void)initTiltShiftPointWithFrame:(CGRect)frame;
- (void)resetImageTiltShiftWithImage:(UIImage*)image;
- (void)flashBlur;
- (void)clearAllEffectImage;
@end

@implementation FTImageView

@synthesize ftLayerView,
            mtFinger,
            imageOrigin, imageFilter,
            filterMode,
            filtersBuffer,
            frameImageAspectFit,
            mtTiltShift,
            isCanActive, isRound,
            sizeImageOrigin,
            centerLayerPoint,
            currentLayerP1, currentLayerP2,
            currentTiltP1, currentTiltP2,
            radiusLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization FTImageView
        self.filterMode = PDImageFilterModeFinger;
        
        // init Finger
        self.mtFinger = [[MTFinger alloc] init];
        
        // init buffer for caching filter effect
        self.filtersBuffer = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

- (void)dealloc
{
	self.mtFinger = nil;
	self.filtersBuffer = nil;
	self.imageOrigin = nil;
	self.imageFilter = nil;
	self.imageTiltShift = nil;
	self.ftLayerView = nil;
}

- (void)setImageInput:(UIImage *)image
{
    // set input image
    self.imageOrigin = image;
    self.image = self.imageOrigin;
    
    self.imageFilter = self.imageOrigin;
    
    // init frame and layer for image
    [self initFrameAndLayerForImage:image];
}

#pragma mark - Filter Mode

- (void)changeFilterMode:(PDImageFilterMode)filtersMode
{
    self.filterMode = filtersMode;
    [self.ftLayerView setFilterMode:self.filterMode];
    [self initLayerViewWithFrame:self.frameImageAspectFit];
    
    if (self.filterMode == PDImageFilterModeFinger) {
        self.image = self.imageFilter;
    }
    else {
        // init TiltShift For Image
        self.mtTiltShift = [[MTTiltShift alloc] initWithImage:self.imageFilter];
        [self initTiltShiftPointWithFrame:self.frameImageAspectFit];
    }
    self.isCanActive = YES;
}


#pragma mark - Filter

- (UIImage *)filteredImageWithImage:(UIImage *)image filter:(NSInteger)filterCase
{
    
    switch (filterCase) {
        case 0:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m00"];
#pragma clang diagnostic pop
            break;
        }
        case 1:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m01"];
#pragma clang diagnostic pop
            break;
        }
        case 2:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m02"];
#pragma clang diagnostic pop
            break;
        }
        case 3:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m03"];
#pragma clang diagnostic pop
            break;
        }
        case 4:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m04"];
#pragma clang diagnostic pop
            break;
        }
        case 5:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m05"];
#pragma clang diagnostic pop
            break;
        }
        case 6:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m06"];
#pragma clang diagnostic pop
            
            break;
        }
        case 7:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m07"];
#pragma clang diagnostic pop
            break;
        }
        case 8:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m08"];
#pragma clang diagnostic pop
            break;
        }
        case 9:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m09"];
#pragma clang diagnostic pop
            break;
        }
        case 10:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m10"];
#pragma clang diagnostic pop
            break;
            
        }
        case 11:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m11"];
#pragma clang diagnostic pop
            break;
        }
        case 12:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m12"];
#pragma clang diagnostic pop
            break;
        }
        case 13:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m13"];
#pragma clang diagnostic pop
            break;
        }
        case 14:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m14"];
#pragma clang diagnostic pop
            break;
        }
        case 15:{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL _track = NSSelectorFromString(@"trackTime:");
            return [image performSelector:_track withObject:@"m15"];
#pragma clang diagnostic pop
            break;
        }
        default:
            return image;
            break;
    }
    return image;
}

- (void)filteredImageAtIndex:(NSInteger)filterCase
{
    if (filterCase==0) {
        [self clearAllEffectImage];
    }
    else
    {
        if ([self.filtersBuffer objectForKey:[NSString stringWithFormat:@"%zd",filterCase]]) {
            self.image = (UIImage*)[self.filtersBuffer objectForKey:[NSString stringWithFormat:@"%zd",filterCase]];
        }
        else {
            self.image = [self filteredImageWithImage:self.imageOrigin filter:filterCase];
						if (self.image) {
							[self.filtersBuffer setObject:self.image forKey:[NSString stringWithFormat:@"%zd", filterCase]];
							self.imageFilter = self.image;
						}
        }
        [self resetImageTiltShiftWithImage:self.image];
    }
    self.isCanActive = YES;
}

- (void)clearFiltersBuffer
{
    [self.filtersBuffer removeAllObjects];
}

#pragma mark - Finger

- (void)fingerImageWithTouchPoint:(CGPoint)touchPoint
{
    self.ftLayerView.alpha = 1.0;
    [self.ftLayerView setCircleCenter:touchPoint];
    CGPoint center = CGPointMake(self.ftLayerView.frame.size.width/2, self.ftLayerView.frame.size.height/2);
    CGFloat x = (CGFloat)(touchPoint.x-center.x)/(self.ftLayerView.frame.size.width/2);
    CGFloat y = (CGFloat)(touchPoint.y-center.y)/(self.ftLayerView.frame.size.height);
    self.image = [self.mtFinger imageFingerFromImage:self.imageFilter atPointX:x andY:y];
    [self.filtersBuffer removeAllObjects];
}

#pragma mark - TiltShift

- (void)initLayerViewWithFrame:(CGRect)frame
{
    if (self.ftLayerView) {
        [self.ftLayerView removeFromSuperview];
        self.ftLayerView = nil;
    }
    self.ftLayerView = [[FTLayerView alloc] initWithFrame:frame];
    [self.ftLayerView setFilterMode:self.filterMode];
    self.ftLayerView.alpha = 0;
    [self addSubview:self.ftLayerView];
}

- (void)initFrameAndLayerForImage:(UIImage *)image
{
    // get actual size of image
    self.sizeImageOrigin = image.size;
    
    // init LayerView for Finger and Tilt-Shift
    self.frameImageAspectFit = [self imageFrameScaleAspectFit:self];
    [self initLayerViewWithFrame:self.frameImageAspectFit];
}

- (void)initLayerPointWithFrame:(CGRect)frame
{
    // init TiltShift: the first tilt-shift point is center of image
    self.radiusLayer = radiusLayerDefault;
    
    // init default point for layer
    self.centerLayerPoint = CGPointMake(frame.size.width/2, frame.size.height/2);
    self.currentLayerP1 = CGPointMake(centerLayerPoint.x, centerLayerPoint.y-self.radiusLayer);
    self.currentLayerP2 = CGPointMake(centerLayerPoint.x, centerLayerPoint.y+self.radiusLayer);
}

- (void)initTiltShiftPointWithFrame:(CGRect)frame
{
    // init TiltShift: the first tilt-shift point is center of image
    [self initLayerPointWithFrame:frame];
    
    self.ftLayerView.touchPoint1 = self.currentLayerP1;
    self.ftLayerView.touchPoint2 = self.currentLayerP2;
    [self.ftLayerView setCircleCenter:centerLayerPoint];
    [self.ftLayerView setRadius:self.radiusLayer];
    
    self.currentTiltP1 = [self pointImageOriginFromImageScaleAspectFitPoint:self.currentLayerP1];
    self.currentTiltP2 = [self pointImageOriginFromImageScaleAspectFitPoint:self.currentLayerP2];
    
    [self flashBlur];
    if (self.filterMode == PDImageFilterModeTiltShiftCircle)
        self.isRound = YES;
    else if (self.filterMode == PDImageFilterModeTiltShiftSquare)
        self.isRound = NO;
    self.image = [self.mtTiltShift createBlurImageWithPoint1:self.currentTiltP1 andPoint2:self.currentTiltP2 isRound:isRound];
}

- (void)resetImageTiltShiftWithImage:(UIImage*)image
{
    [self.mtTiltShift initInforWithImage:image];
    self.ftLayerView.alpha = 0;
    [self touchesEnded:nil withEvent:nil];
    isCanActive = YES;
}

-(void)flashBlur
{
    [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
        self.ftLayerView.alpha = 0.7;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 delay:0.2 options:0 animations:^{
            self.ftLayerView.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}
#pragma mark - Rotate

- (void)rotateImage
{
    self.imageOrigin = [self.imageOrigin rotateDegreesToRadians90];
    self.imageFilter = [self.imageFilter rotateDegreesToRadians90];
    self.image = [self.image rotateDegreesToRadians90];

    [self.filtersBuffer removeAllObjects];
    
    // reinit frame and layer for image
    [self initFrameAndLayerForImage:self.imageFilter];
    
    if (self.filterMode==PDImageFilterModeTiltShiftCircle || self.filterMode==PDImageFilterModeTiltShiftSquare) {
        // init TiltShift For Image
        self.mtTiltShift = [[MTTiltShift alloc] initWithImage:self.imageFilter];
        [self initLayerPointWithFrame:self.frameImageAspectFit];
    }
    self.isCanActive = YES;
}

- (void)clearAllEffectImage
{
    [self.filtersBuffer removeAllObjects];
    self.image = self.imageOrigin;
    self.imageFilter = self.imageOrigin;

    [self.mtTiltShift initInforWithImage:self.imageOrigin];
}

#pragma mark - Touch delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    touchPoint = [self pointImageScaleAspectFitFromImageViewPoint:touchPoint];
    if (touchPoint.x>=0 && touchPoint.x<=self.frameImageAspectFit.size.width && touchPoint.y>=0 && touchPoint.y<=self.frameImageAspectFit.size.height) {
        if (self.filterMode == PDImageFilterModeFinger)
        {
            [self fingerImageWithTouchPoint:touchPoint];
        }
        else
        {
            if (self.isCanActive) {
                self.isCanActive = NO;
                NSSet *allTouches = [event allTouches];
                int x1,y1,x2,y2;
                if([allTouches count]==1)
                {
                    UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
                    CGPoint point = [touch locationInView:self];
                    point = [self pointImageScaleAspectFitFromImageViewPoint:point];
                    int x=(self.currentLayerP1.x+self.currentLayerP2.x)/2;
                    int y=(self.currentLayerP1.y+self.currentLayerP2.y)/2;
                    x1= self.currentLayerP1.x+point.x-x;
                    x2= self.currentLayerP2.x+point.x-x;
                    y1= self.currentLayerP1.y+point.y-y;
                    y2= self.currentLayerP2.y+point.y-y;
                }
                else
                {
                    UITouch*touch=[[allTouches allObjects] objectAtIndex:0];
                    CGPoint point1 = [touch locationInView:self];
                    point1 = [self pointImageScaleAspectFitFromImageViewPoint:point1];
                    x1=point1.x;
                    y1=point1.y;
                    touch = [[allTouches allObjects] objectAtIndex:1];
                    CGPoint point2 =[touch locationInView:self];
                    point2 = [self pointImageScaleAspectFitFromImageViewPoint:point2];
                    x2=point2.x;
                    y2=point2.y;
                }
                self.currentLayerP1 = CGPointMake(x1, y1);
                self.currentLayerP2 = CGPointMake(x2, y2);
                self.currentTiltP1 = [self pointImageOriginFromImageScaleAspectFitPoint:self.currentLayerP1];
                self.currentTiltP2 = [self pointImageOriginFromImageScaleAspectFitPoint:self.currentLayerP2];
                self.ftLayerView.touchPoint1 = self.currentLayerP1;
                self.ftLayerView.touchPoint2 = self.currentLayerP2;
                CGPoint center;
                center.x=(self.currentLayerP1.x+self.currentLayerP2.x)/2;
                center.y=(self.currentLayerP1.y+self.currentLayerP2.y)/2;
                int x=self.currentLayerP2.x-self.currentLayerP1.x;
                int y=self.currentLayerP2.y-self.currentLayerP1.y;
                if(x<0)x=-x;
                if(y<0)y=-y;
                self.radiusLayer = (x+y)/2;
                self.centerLayerPoint = center;
                
                // draw layer at layer point
                [self.ftLayerView setCircleCenter:self.centerLayerPoint];
                [self.ftLayerView setRadius:self.radiusLayer];
                self.ftLayerView.alpha = 0.7;
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    touchPoint = [self pointImageScaleAspectFitFromImageViewPoint:touchPoint];
    if (touchPoint.x>=0 && touchPoint.x<=self.frameImageAspectFit.size.width && touchPoint.y>=0 && touchPoint.y<=self.frameImageAspectFit.size.height)
    {
        if (self.filterMode == PDImageFilterModeFinger)
        {
            [self fingerImageWithTouchPoint:touchPoint];
        }
        else
        {
            self.isCanActive = YES;
            [self touchesBegan:touches withEvent:event];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.ftLayerView.alpha = 0;
    if (self.filterMode!=PDImageFilterModeFinger) {
        // tilt-shift image at tilt point
        self.image = [self.mtTiltShift createBlurImageWithPoint1:self.currentTiltP1 andPoint2:self.currentTiltP2 isRound:isRound];
        [self.filtersBuffer removeAllObjects];
    }
    self.isCanActive = YES;
}

#pragma mark - Utility proccess touch and frame image scale aspect fit

- (CGRect)imageFrameScaleAspectFit:(UIImageView *)imageView
{
    float imageRatio = imageView.image.size.width / imageView.image.size.height;
    
    float viewRatio = imageView.frame.size.width / imageView.frame.size.height;
    
    if(imageRatio < viewRatio)
    {
        float scale = imageView.frame.size.height / imageView.image.size.height;
        
        float width = scale * imageView.image.size.width;
        
        float topLeftX = (imageView.frame.size.width - width) * 0.5;
        
        return CGRectMake(topLeftX, 0, width, imageView.frame.size.height);
    }
    else
    {
        float scale = imageView.frame.size.width / imageView.image.size.width;
        
        float height = scale * imageView.image.size.height;
        
        float topLeftY = (imageView.frame.size.height - height) * 0.5;
        
        return CGRectMake(0, topLeftY, imageView.frame.size.width, height);
    }
}

- (CGPoint)pointImageScaleAspectFitFromImageViewPoint:(CGPoint)point
{
    point.x = point.x - (self.frame.size.width-self.frameImageAspectFit.size.width)/2;
    point.y = point.y - (self.frame.size.height-self.frameImageAspectFit.size.height)/2;
    return point;
}

- (CGPoint)pointImageOriginFromImageScaleAspectFitPoint:(CGPoint)point
{
    point.x = point.x*(self.sizeImageOrigin.width/self.frameImageAspectFit.size.width);
    point.y = point.y*(self.sizeImageOrigin.height/self.frameImageAspectFit.size.height);
    return point;
}

@end
