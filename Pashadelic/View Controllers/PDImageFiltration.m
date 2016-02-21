//
//  PDImageFiltration.m
//  Pashadelic
//
//  Created by Duc Long on 7/1/13.
//
//

#import "PDImageFiltration.h"
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation PDImageFiltration

- (id) initWithImage:(UIImage *)newImage atIndex:(NSInteger)index
{
    if (self = [super init]) {
        self.image = newImage;
        self.index = index;
    }
    return self;
}


- (void)main {
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        SEL filterFunc;
        if (self.index >= 10) {
            filterFunc = NSSelectorFromString([NSString stringWithFormat:@"m%zd",self.index]);
        } else {
            filterFunc = NSSelectorFromString([NSString stringWithFormat:@"m0%zd",self.index]);
        }
        
        if (self.isCancelled)
            return;
        
        UIImage *tempImage;
        SuppressPerformSelectorLeakWarning(tempImage = [self.image performSelector:filterFunc];);
        
        if (self.isCancelled)
            return;
        if(tempImage){
            self.image = tempImage;
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageFiltrationDidFinish:) withObject:self waitUntilDone:NO];
        }
    }
    
}
@end
