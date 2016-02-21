//
//  MTTiltShift.m
//  Pashadelic
//
//  Created by TungNT2 on 2/4/13.
//
//

#import "MTTiltShift.h"
#define MAXSIZE 8
int SIZE= 3;
int size=3;
@implementation MTTiltShift
@synthesize width;
@synthesize height;
@synthesize pInside;
@synthesize radialBlurFilter;

- (id)init {
    self = [super init];
    if (self) {
        self.radialBlurFilter = [[[GPUImageGaussianSelectiveBlurFilter alloc] init] autorelease];
        self.squareBlruFilter = [[[GPUImageTiltShiftFilter alloc] init] autorelease];
    }
    return self;
}

- (UIImage *)imageTiltShiftWithImage:(UIImage *)image fromPointCenter:(CGPoint)center andRadius:(CGFloat)radius
{
    [self.radialBlurFilter setExcludeCirclePoint:center];
    [self.radialBlurFilter setExcludeCircleRadius:radius];
    GPUImagePicture *stillImageSource = [[[GPUImagePicture alloc] initWithImage:image] autorelease];
    [stillImageSource addTarget:self.radialBlurFilter];
    [self.radialBlurFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    return [self.radialBlurFilter imageFromCurrentFramebufferWithOrientation:UIImageOrientationUp];
}

- (UIImage *)imageTiltShiftWithImage:(UIImage *)image fromTopFocusLevel:(CGFloat)topFocusLevel andBottomFocusLevel:(CGFloat)bottomFocusLevel
{
    [self.squareBlruFilter setTopFocusLevel:topFocusLevel];
    [self.squareBlruFilter setBottomFocusLevel:bottomFocusLevel];
    GPUImagePicture *stillImageSource = [[[GPUImagePicture alloc] initWithImage:image] autorelease];
    [stillImageSource addTarget:self.squareBlruFilter];
    [self.squareBlruFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    return [self.squareBlruFilter imageFromCurrentFramebufferWithOrientation:UIImageOrientationUp];
}

- (void)dealloc
{
	self.radialBlurFilter = nil;
	self.squareBlruFilter = nil;
	if (pInside) {
		free(pInside);
	}
	[super dealloc];
}

unsigned char *rValue,*gValue,*bValue,*aValue,*value,*blurBitmap;
int *rSum,*gSum,*bSum;
UIImage *paraImage;

NSInteger offset[MAXSIZE+2];

NSInteger length;
+ (CGContextRef) newBitmapRGBA8ContextFromImage:(CGImageRef) image {
	CGContextRef context = NULL;
	CGColorSpaceRef colorSpace;
	uint32_t *bitmapData;
	
	size_t bitsPerPixel = 32;
	size_t bitsPerComponent = 8;
	size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
	
	size_t width = CGImageGetWidth(image);
	size_t height = CGImageGetHeight(image);
	
	size_t bytesPerRow = width * bytesPerPixel;
	size_t bufferLength = bytesPerRow * height;
	
	colorSpace = CGColorSpaceCreateDeviceRGB();
	
	if(!colorSpace) {
		NSLog(@"Error allocating color space RGB\n");
		return NULL;
	}
	
	// Allocate memory for image data
	bitmapData = (uint32_t *)malloc(bufferLength);
	
	if(!bitmapData) {
		NSLog(@"Error allocating memory for bitmap\n");
		CGColorSpaceRelease(colorSpace);
		return NULL;
	}
	
	//Create bitmap context
	
	context = CGBitmapContextCreate(bitmapData,
                                    width,
                                    height,
                                    bitsPerComponent,
                                    bytesPerRow,
                                    colorSpace,
                                    (CGBitmapInfo) kCGImageAlphaPremultipliedLast);	// RGBA
	if(!context) {
		free(bitmapData);
		NSLog(@"Bitmap context not created");
	}
	
	CGColorSpaceRelease(colorSpace);
	
	return context;
}


-(void)initInforWithImage:(UIImage*)image{
    
    if(pInside)
        free(pInside);
    if(rValue)
        free(rValue);
    if(gValue)
        free(gValue);
    if(bValue)
        free(bValue);
    if(aValue)
        free(aValue);
    if(blurBitmap)
        free(blurBitmap);
    if(rSum){
        free(rSum);
        free(gSum);
        free(bSum);
    }
    
    CGImageRef imageRef = image.CGImage;
    
	CGContextRef context = [MTTiltShift newBitmapRGBA8ContextFromImage:imageRef];
	if(!context) {
		return ;
	}
	paraImage = [[UIImage alloc]initWithData:UIImagePNGRepresentation(image)];
	self.width = CGImageGetWidth(imageRef);
	self.height = CGImageGetHeight(imageRef);
    length=width*height;
	
	CGRect rect = CGRectMake(0, 0, width, height);
	CGContextDrawImage(context, rect, imageRef);
	unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);
    
    //tunglv create blurred image and blurred context
    UIImage *blurImage = [self stackBlur1:4 and:paraImage];
    CGImageRef blurImageRef = blurImage.CGImage;
    CGContextRef blurContext = [MTTiltShift newBitmapRGBA8ContextFromImage:blurImageRef];
	if(!blurContext) {
		CGContextRelease(context);
		[paraImage release];
		return ;
	}
	CGContextDrawImage(blurContext, rect, blurImageRef);
	unsigned char *blurBitmapData = (unsigned char *)CGBitmapContextGetData(blurContext);
    blurBitmap = NULL;
    blurBitmap = (unsigned char *)malloc(sizeof(unsigned char) * width*4 * height);
    int l=-4;
    for(int i = 0; i < width*height; i++) {
        l+=4;
        blurBitmap[l] = blurBitmapData[l];
        blurBitmap[l+1] = blurBitmapData[l+1];
        blurBitmap[l+2] = blurBitmapData[l+2];
    }
    //end
    
    rValue=gValue=bValue=aValue=NULL;
	if(bitmapData) {
        
        offset[0]=0;
        for(int i=1;i<MAXSIZE+2;i++){
            offset[i]=width+offset[i-1];
        }
        
		rValue = (unsigned char *)malloc(sizeof(unsigned char) *width*height);
		gValue = (unsigned char *)malloc(sizeof(unsigned char) *width*height);
        bValue = (unsigned char *)malloc(sizeof(unsigned char) *width*height);
        aValue = (unsigned char *)malloc(sizeof(unsigned char) *width*height);
        pInside = (unsigned char *)malloc(sizeof(unsigned char) *width*height);
        
        rSum = (int *)malloc(sizeof(int) *width*height);
        gSum = (int *)malloc(sizeof(int) *width*height);
        bSum = (int *)malloc(sizeof(int) *width*height);
        
		if(rValue&&gValue&&bValue&&aValue) {	// Copy the data
            int k=-4;
			for(int i = 0; i < width*height; i++) {
                k+=4;
				rValue[i]=bitmapData[k];
                gValue[i]=bitmapData[k+1];
                bValue[i]=bitmapData[k+2];
                aValue[i]=bitmapData[k+3];
                
			}
            
            rSum[0]=rValue[0];
            for(int i=1;i<width;i++){
                rSum[i]=rSum[i-1]+rValue[i];
            }
            k=width;
            for(int i=1;i<height;i++){
                for(int j=0;j<width;j++){
                    if(j==0){
                        rSum[k]=rValue[k]+rSum[k-width];
                    }else{
                        rSum[k]=rValue[k]+rSum[k-1]+rSum[k-width]-rSum[k-width-1];
                    }
                    k++;
                }
            }
            
            gSum[0]=gValue[0];
            for(int i=1;i<width;i++){
                gSum[i]=gSum[i-1]+gValue[i];
            }
            k=width;
            for(int i=1;i<height;i++){
                for(int j=0;j<width;j++){
                    if(j==0){
                        gSum[k]=gValue[k]+gSum[k-width];
                    }else{
                        gSum[k]=gValue[k]+gSum[k-1]+gSum[k-width]-gSum[k-width-1];
                    }
                    k++;
                }
            }
            
            bSum[0]=bValue[0];
            for(int i=1;i<width;i++){
                bSum[i]=bSum[i-1]+bValue[i];
            }
            k=width;
            for(int i=1;i<height;i++){
                for(int j=0;j<width;j++){
                    if(j==0){
                        bSum[k]=bValue[k]+bSum[k-width];
                    }else{
                        bSum[k]=bValue[k]+bSum[k-1]+bSum[k-width]-bSum[k-width-1];
                    }
                    k++;
                }
            }
//            NSLog(@"--  %i",bSum[width*height-1]);
		}
//        NSLog(@"time Start");
        //[self createDataBlurBySumTable];
        //CreateCGImageByBlurringImage_tit(imageRef,5,5);
        //[self stackBlur:10 and:imageRef];
//        NSLog(@"time End");
        
	} else {
        NSLog(@"Error getting bitmap pixel data\n");
	}
    free(bitmapData);
    free(blurBitmapData);
	CGContextRelease(context);
    CGContextRelease(blurContext);
	[paraImage release];
}

-(id)initWithImage:(UIImage*)image{
    self = [self init];
    if (self) {
        [self initInforWithImage:image];
    }
    return self;
}

-(int)distanceBetweenPoint:(CGPoint)p and:(int)x and:(int)y{
    return (int)sqrt((p.x-x)*(p.x-x)+(p.y-y)*(p.y-y));
}

-(void)initPixcellInsideWithPoint:(CGPoint)point andRadius:(int)R Scale:(int)scale{
    int k=0;
    for(int y=0;y<height;y++){
        for(int x=0;x<width;x++){
            int r=[self distanceBetweenPoint:point and:x and:y];
            if(r<=R){
                pInside[k]=0;
            }
            else{
                int value=r-R;
                if(value>255){
                    value=255;
                }
                pInside[k]=value;
            }
            k++;
        }
    }
    
}


-(void)initPixcellInsideWithPoint1:(CGPoint)p1 andPoint2:(CGPoint)p2 Scale:(int)scale{
    CGPoint p;
    p.x=(p1.x+p2.x)/2;
    p.y=(p1.y+p2.y)/2;
    int A=p1.x-p2.x;
    int B=p1.y-p2.y;
    int C=-A*p.x-B*p.y;
    double D=sqrt(A*A+B*B);
    int R=(double)abs(A*p1.x+B*p1.y+C)/D;
    int k=0;
    for(int y=0;y<height;y++){
        for(int x=0;x<width;x++){
            int r=(double)abs(A*x+B*y+C)/D;;
            if(r<=R){
                pInside[k]=0;
            }
            else{
                int value=r-R;
                if(value>255)value=255;
                pInside[k]=value;
            }
            k++;
        }
    }
}

- (void)initPixcellInsideWithPoint:(CGPoint)point andRadius:(int)r{
    
    CGPoint p = CGPointZero;
    p.x=point.x;
    p.y=point.y;
    
    int y1=p.y-r;
    int y2=p.y+r;
    int r2=r*r;
    if(y1<0)y1=0;
    if(y2>=height)y2=height-1;
    
    int k=0;
    for(int y=0;y<y1;y++){
        for(int x=0;x<width;x++){
            pInside[k]=1;
            k++;
        }
    }
    k=y1*width;
    for(int y=y1;y<=y2;y++){
        double h=r2-(y-p.y)*(y-p.y);
        int t=sqrt(h);
        int x1=p.x-t;
        int x2=p.x+t;
        if(x1<0)x1=0;
        if(x2>=width)x2=width-1;
        for(int i=0;i<x1;i++){
            pInside[k]=1;
            k++;
        }
        for(int i=x1;i<=x2;i++){
            pInside[k]=0;
            k++;
        }
        for(int i=x2+1;i<width;i++){
            pInside[k]=1;
            k++;
        }
    }
    k=y2*width;
    for(int y=y2+1;y<height;y++){
        for(int x=0;x<width;x++){
            pInside[k]=1;
            k++;
        }
    }
}

-(void)initPixcellInsideWithPoint1:(CGPoint)p1 andPoint2:(CGPoint)p2{
    int x1=p1.x;
    int x2=p2.x;
    int y1=p1.y;
    int y2=p2.y;
    int a=-(x1-x2);
    int b=y1-y2;
    if(a==0){
        if(y1>y2){
            int t=y1;
            y1=y2;
            y2=t;
        }
        int k=0;
        for(int y=0;y<=y1;y++){
            for(int x=0;x<width;x++){
                pInside[k]=1;
                k++;
            }
        }
        for(int y=y1+1;y<y2;y++){
            for(int x=0;x<width;x++){
                pInside[k]=0;
                k++;
            }
        }
        for(int y=y2;y<height;y++){
            for(int x=0;x<width;x++){
                pInside[k]=1;
                k++;
            }
        }
        return;
    }
    int k=0;
    for(int y=0;y<height;y++){
        int h1=(b*(y-y1))/a+x1;
        int h2=(b*(y-y2))/a+x2;
        if(h1<0)h1=0;
        if(h2<0)h2=0;
        if(h2>=width)h2=width-1;
        if(h1>=width)h1=width-1;
        
        for(int i=0;i<h1;i++){
            pInside[k]=1;
            k++;
        }
        for(int i=h1;i<=h2;i++){
            pInside[k]=0;
            k++;
        }
        for(int i=h2+1;i<width;i++){
            pInside[k]=1;
            k++;
        }
    }
    
    
}

+ (UIImage *) convertBitmapRGBA8ToUIImage:(unsigned char *) buffer
                                withWidth:(int) width
                               withHeight:(int) height {
	
	
	size_t bufferLength = width * height * 4;
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
	size_t bitsPerComponent = 8;
	size_t bitsPerPixel = 32;
	size_t bytesPerRow = 4 * width;
	
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	if(colorSpaceRef == NULL) {
		NSLog(@"Error allocating color space");
		CGDataProviderRelease(provider);
		return nil;
	}
	
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	CGImageRef iref = CGImageCreate(width,
                                    height,
                                    bitsPerComponent,
                                    bitsPerPixel,
                                    bytesPerRow,
                                    colorSpaceRef,
                                    bitmapInfo,
                                    provider,	// data provider
                                    NULL,		// decode
                                    YES,			// should interpolate
                                    renderingIntent);
    
	
	CGContextRef context = CGBitmapContextCreate(NULL,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpaceRef,
                                                 bitmapInfo);
	
	if(context == NULL) {
		NSLog(@"Error context not created");
	}
	
	UIImage *image = nil;
	if(context) {
		
		CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), iref);
		
		CGImageRef imageRef = CGBitmapContextCreateImage(context);
		
		// Support both iPad 3.2 and iPhone 4 Retina displays with the correct scale
		if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
			float scale = [[UIScreen mainScreen] scale];
			image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
		} else {
			image = [UIImage imageWithCGImage:imageRef];
		}
		
		CGImageRelease(imageRef);
		CGContextRelease(context);
	}
	
	CGColorSpaceRelease(colorSpaceRef);
	CGImageRelease(iref);
	CGDataProviderRelease(provider);
	return image;
}


-(UIImage*)createBlurImageWithPoint1:(CGPoint)p1 andPoint2:(CGPoint)p2 isRound:(bool)isRound{
    if(!pInside)pInside=(unsigned char *)malloc(sizeof(unsigned char) * width*4 * height);
    if(!isRound){
        [self initPixcellInsideWithPoint1:p1 andPoint2:p2 Scale:1];
    }else{
        CGPoint p;
        p.x=(p1.x+p2.x)/2;
        p.y=(p1.y+p2.y)/2;
        int x=p2.x-p1.x;
        int y=p2.y-p1.y;
        if(x<0)x=-x;
        if(y<0)y=-y;
        [self initPixcellInsideWithPoint:p andRadius:(x+y)/2 Scale:1];
    }
    unsigned char *newBitmap = NULL;
    newBitmap = (unsigned char *)malloc(sizeof(unsigned char) * width*4 * height);
    if(!newBitmap) return nil;
    int k=0;
    for(int i=0;i<height*width;i++){
        if(pInside[i]>0){
            int index=pInside[i];
            int index1=index+20;
            newBitmap[k]=(blurBitmap[k]*index+20*rValue[i])/index1;
            newBitmap[k+1]=(blurBitmap[k+1]*index+20*gValue[i])/index1;
            newBitmap[k+2]=(blurBitmap[k+2]*index+20*bValue[i])/index1;
            //newBitmap[k+3]=(blurBitmap[k+3]*index+10*aValue[i])/index1;
        }else{
            newBitmap[k]=rValue[i];
            newBitmap[k+1]=gValue[i];
            newBitmap[k+2]=bValue[i];
            //newBitmap[k+3]=aValue[i];
        }
        newBitmap[k+3]=aValue[i];
        k+=4;
    }
    UIImage*image=[MTTiltShift convertBitmapRGBA8ToUIImage:newBitmap withWidth:width withHeight:height];
    if(newBitmap)free(newBitmap);
    return image;
}

-(unsigned char)blurRGBA:(int)index and:(int)row and: (int )col{
    unsigned char nValue=value[index];
    int sum=nValue;
    int wei=1;
    int cIndex=index;
    for(int i=-SIZE;i<SIZE;i++){
        int k=col+i;
        if(k<0||k>=width)continue;
        wei++;
        sum+=(int)value[cIndex+i];
    }
    cIndex=index;
    int nRow=row;
    for(int i=0;i<SIZE;i++){
        cIndex-=width;
        nRow--;
        if(nRow<0)break;
        for(int j=-SIZE;j<SIZE;j++){
            int k=col+j;
            if(k<0||k>=width)continue;
            wei++;
            sum+=(int)value[cIndex+j];
        }
    }
    cIndex=index;
    nRow=row;
    for(int i=0;i<SIZE;i++){
        cIndex+=width;
        nRow++;
        if(nRow>=height)break;
        for(int j=-SIZE;j<SIZE;j++){
            int k=col+j;
            if(k<0||k>=width)continue;
            wei++;
            sum+=(int)value[cIndex+j];
        }
    }
    nValue=(unsigned char)(sum/wei);
    return nValue;
}

-(void)createDataBlur{
    blurBitmap = NULL;
    blurBitmap = (unsigned char *)malloc(sizeof(unsigned char) * width*4 * height);
    if(!blurBitmap) return ;
    int k=-4;
    int index=-1;
    value=rValue;
    for(int i=0;i<height;i++){
        for(int j=0;j<width;j++){
            k+=4;
            index++;
            blurBitmap[k]=[self blurRGBA:index and:i and:j];
        }
        
    }
    k=-4;
    index=-1;
    value=gValue;
    for(int i=0;i<height;i++){
        for(int j=0;j<width;j++){
            k+=4;
            index++;
            blurBitmap[k+1]=[self blurRGBA:index and:i and:j];
        }
        
    }
    k=-4;
    index=-1;
    value=bValue;
    for(int i=0;i<height;i++){
        for(int j=0;j<width;j++){
            k+=4;
            index++;
            blurBitmap[k+2]=[self blurRGBA:index and:i and:j];
        }
        
    }
    k=-4;
    index=-1;
    value=aValue;
    for(int i=0;i<height;i++){
        for(int j=0;j<width;j++){
            k+=4;
            index++;
            blurBitmap[k+3]=aValue[index];
            //[self blurRGBA:index and:i and:j];
        }
        
    }
}

//tunglv change algorithm for tiltShift

- (UIImage*) stackBlur1:(NSUInteger)inradius and:(UIImage *)paraImage
{
	int radius=inradius; // Transform unsigned into signed for further operations
	if (radius<1){
		return paraImage;
	}
    // Suggestion xidew to prevent crash if size is null
	if (CGSizeEqualToSize(paraImage.size, CGSizeZero)) {
        return paraImage;
    }
    
    //	return [other applyBlendFilter:filterOverlay  other:self context:nil];
	// First get the image into your data buffer
    CGImageRef inImage = paraImage.CGImage;
    int nbPerCompt=CGImageGetBitsPerPixel(inImage);
    if(nbPerCompt!=32){
        UIImage *tmpImage=[self normalize:paraImage];
        inImage=tmpImage.CGImage;
    }
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    UInt8 * m_PixelBuf=malloc(CFDataGetLength(m_DataRef));
    CFDataGetBytes(m_DataRef,
                   CFRangeMake(0,CFDataGetLength(m_DataRef)) ,
                   m_PixelBuf);
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,
											 CGImageGetWidth(inImage),
											 CGImageGetHeight(inImage),
											 CGImageGetBitsPerComponent(inImage),
											 CGImageGetBytesPerRow(inImage),
											 CGImageGetColorSpace(inImage),
											 CGImageGetBitmapInfo(inImage)
											 );
	int w=CGImageGetWidth(inImage);
	int h=CGImageGetHeight(inImage);
	int wm=w-1;
	int hm=h-1;
	int wh=w*h;
	int div=radius+radius+1;
	
	int *r=malloc(wh*sizeof(int));
	int *g=malloc(wh*sizeof(int));
	int *b=malloc(wh*sizeof(int));
	memset(r,0,wh*sizeof(int));
	memset(g,0,wh*sizeof(int));
	memset(b,0,wh*sizeof(int));
	int rsum,gsum,bsum,x,y,i,p,yp,yi,yw;
	int *vmin = malloc(sizeof(int)*MAX(w,h));
	memset(vmin,0,sizeof(int)*MAX(w,h));
	int divsum=(div+1)>>1;
	divsum*=divsum;
	int *dv=malloc(sizeof(int)*(256*divsum));
	for (i=0;i<256*divsum;i++){
		dv[i]=(i/divsum);
	}
	
	yw=yi=0;
	
	int *stack=malloc(sizeof(int)*(div*3));
	int stackpointer;
	int stackstart;
	int *sir;
	int rbs;
	int r1=radius+1;
	int routsum,goutsum,boutsum;
	int rinsum,ginsum,binsum;
	memset(stack,0,sizeof(int)*div*3);
	
	for (y=0;y<h;y++){
		rinsum=ginsum=binsum=routsum=goutsum=boutsum=rsum=gsum=bsum=0;
		
		for(int i=-radius;i<=radius;i++){
			sir=&stack[(i+radius)*3];
			int offset=(yi+MIN(wm,MAX(i,0)))*4;
			sir[0]=m_PixelBuf[offset];
			sir[1]=m_PixelBuf[offset+1];
			sir[2]=m_PixelBuf[offset+2];
			
			rbs=r1-abs(i);
			rsum+=sir[0]*rbs;
			gsum+=sir[1]*rbs;
			bsum+=sir[2]*rbs;
			if (i>0){
				rinsum+=sir[0];
				ginsum+=sir[1];
				binsum+=sir[2];
			} else {
				routsum+=sir[0];
				goutsum+=sir[1];
				boutsum+=sir[2];
			}
		}
		stackpointer=radius;
		
		
		for (x=0;x<w;x++){
			r[yi]=dv[rsum];
			g[yi]=dv[gsum];
			b[yi]=dv[bsum];
			
			rsum-=routsum;
			gsum-=goutsum;
			bsum-=boutsum;
			
			stackstart=stackpointer-radius+div;
			sir=&stack[(stackstart%div)*3];
			
			routsum-=sir[0];
			goutsum-=sir[1];
			boutsum-=sir[2];
			
			if(y==0){
				vmin[x]=MIN(x+radius+1,wm);
			}
			int offset=(yw+vmin[x])*4;
			sir[0]=m_PixelBuf[offset];
			sir[1]=m_PixelBuf[offset+1];
			sir[2]=m_PixelBuf[offset+2];
			rinsum+=sir[0];
			ginsum+=sir[1];
			binsum+=sir[2];
			
			rsum+=rinsum;
			gsum+=ginsum;
			bsum+=binsum;
			
			stackpointer=(stackpointer+1)%div;
			sir=&stack[((stackpointer)%div)*3];
			
			routsum+=sir[0];
			goutsum+=sir[1];
			boutsum+=sir[2];
			
			rinsum-=sir[0];
			ginsum-=sir[1];
			binsum-=sir[2];
			
			yi++;
		}
		yw+=w;
	}
	for (x=0;x<w;x++){
		rinsum=ginsum=binsum=routsum=goutsum=boutsum=rsum=gsum=bsum=0;
		yp=-radius*w;
		for(i=-radius;i<=radius;i++){
			yi=MAX(0,yp)+x;
			
			sir=&stack[(i+radius)*3];
			
			sir[0]=r[yi];
			sir[1]=g[yi];
			sir[2]=b[yi];
			
			rbs=r1-abs(i);
			
			rsum+=r[yi]*rbs;
			gsum+=g[yi]*rbs;
			bsum+=b[yi]*rbs;
			
			if (i>0){
				rinsum+=sir[0];
				ginsum+=sir[1];
				binsum+=sir[2];
			} else {
				routsum+=sir[0];
				goutsum+=sir[1];
				boutsum+=sir[2];
			}
			
			if(i<hm){
				yp+=w;
			}
		}
		yi=x;
		stackpointer=radius;
		for (y=0;y<h;y++){
			//			m_PixelBuf[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
			int offset=yi*4;
			m_PixelBuf[offset]=dv[rsum];
			m_PixelBuf[offset+1]=dv[gsum];
			m_PixelBuf[offset+2]=dv[bsum];
			rsum-=routsum;
			gsum-=goutsum;
			bsum-=boutsum;
			
			stackstart=stackpointer-radius+div;
			sir=&stack[(stackstart%div)*3];
			
			routsum-=sir[0];
			goutsum-=sir[1];
			boutsum-=sir[2];
			
			if(x==0){
				vmin[y]=MIN(y+r1,hm)*w;
			}
			p=x+vmin[y];
			
			sir[0]=r[p];
			sir[1]=g[p];
			sir[2]=b[p];
			
			rinsum+=sir[0];
			ginsum+=sir[1];
			binsum+=sir[2];
			
			rsum+=rinsum;
			gsum+=ginsum;
			bsum+=binsum;
			
			stackpointer=(stackpointer+1)%div;
			sir=&stack[(stackpointer)*3];
			
			routsum+=sir[0];
			goutsum+=sir[1];
			boutsum+=sir[2];
			
			rinsum-=sir[0];
			ginsum-=sir[1];
			binsum-=sir[2];
			
			yi+=w;
		}
	}
	free(r);
	free(g);
	free(b);
	free(vmin);
	free(dv);
	free(stack);
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
	CGContextRelease(ctx);
	
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CFRelease(m_DataRef);
    free(m_PixelBuf);
	return finalImage;
}


- (UIImage *) normalize:(UIImage *)paraImage {
    
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL,
                                                         
                                                         paraImage.size.width,
                                                         paraImage.size.height,
                                                         8, (4 * paraImage.size.width),
                                                         genericColorSpace,
                                                         (CGBitmapInfo) kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(genericColorSpace);
    CGContextSetInterpolationQuality(thumbBitmapCtxt, kCGInterpolationDefault);
    CGRect destRect = CGRectMake(0, 0, paraImage.size.width, paraImage.size.height);
    CGContextDrawImage(thumbBitmapCtxt, destRect, paraImage.CGImage);
    CGImageRef tmpThumbImage = CGBitmapContextCreateImage(thumbBitmapCtxt);
    CGContextRelease(thumbBitmapCtxt);
    UIImage *result = [UIImage imageWithCGImage:tmpThumbImage];
    CGImageRelease(tmpThumbImage);
    
    return result;
}

@end
