//
//  PDARAlgorithm.h
//  Pashadelic
//
//  Created by LTT on 3/26/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#define DEGREES_TO_RADIANS (M_PI/180.0)

typedef float mat4f_t[16];	// 4x4 matrix in column major order
typedef float vec4f_t[4];
@interface PDARAlgorithm : NSObject

void createProjectionMatrix(mat4f_t mout, float fovy, float aspect, float zNear, float zFar);
void multiplyMatrixAndVector(vec4f_t vout, const mat4f_t m, const vec4f_t v);
void multiplyMatrixAndMatrix(mat4f_t c, const mat4f_t a, const mat4f_t b);
void transformFromCMRotationMatrix(vec4f_t mout, const CMRotationMatrix *m);
void convertToNUE (float azimuth ,float altitude, float distance, float *e, float *n, float *u);
@end
