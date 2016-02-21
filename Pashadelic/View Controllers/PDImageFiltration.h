//
//  PDImageFiltration.h
//  Pashadelic
//
//  Created by Duc Long on 7/1/13.
//
//

#import <Foundation/Foundation.h>
@class PDImageFiltration;
@protocol ImageFiltrationDelegate <NSObject>
- (void)imageFiltrationDidFinish:(PDImageFiltration *)filtration;
@end

@interface PDImageFiltration : NSOperation
@property (nonatomic, strong) UIImage *image;
@property (assign, nonatomic) NSInteger index;
@property (nonatomic, weak) id <ImageFiltrationDelegate> delegate;

- (id)initWithImage:(UIImage *)newImage atIndex:(NSInteger)index;

@end

