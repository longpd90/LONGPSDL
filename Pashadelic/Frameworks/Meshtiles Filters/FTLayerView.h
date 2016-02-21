//
//  FTLayerView.h
//  Pashadelic
//
//  Created by TungNT2 on 1/30/13.
//
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface FTLayerView : UIView

@property(nonatomic,assign) CGFloat radius;
@property(nonatomic,assign) CGPoint circleCenter, touchPoint1, touchPoint2;
@property(nonatomic,assign) BOOL isRound;
@property(nonatomic,assign) NSInteger filterMode; //0 :finger, 1: circle tilt-shift, 2: square tilt-shift
@property(nonatomic,assign) CGRect holeRect;

@end
