//
//  PDARAlgorithm.m
//  Pashadelic
//
//  Created by LTT on 3/26/14.
//
//

#import "PDARAlgorithm.h"

@implementation PDARAlgorithm

void createProjectionMatrix(mat4f_t mout, float fovy, float aspect, float zNear, float zFar)
{
	float f = 1.0f / tanf(fovy/2.0f);
	
	mout[0] = f / aspect;
	mout[1] = 0.0f;
	mout[2] = 0.0f;
	mout[3] = 0.0f;
	
	mout[4] = 0.0f;
	mout[5] = f;
	mout[6] = 0.0f;
	mout[7] = 0.0f;
	
	mout[8] = 0.0f;
	mout[9] = 0.0f;
	mout[10] = (zFar+zNear) / (zNear-zFar);
	mout[11] = -1.0f;
	
	mout[12] = 0.0f;
	mout[13] = 0.0f;
	mout[14] = 2 * zFar * zNear /  (zNear-zFar);
	mout[15] = 0.0f;
}

// multiply matrix with vector

void multiplyMatrixAndVector(vec4f_t vout, const mat4f_t m, const vec4f_t v)
{
	vout[0] = m[0]*v[0] + m[4]*v[1] + m[8]*v[2] + m[12]*v[3];
	vout[1] = m[1]*v[0] + m[5]*v[1] + m[9]*v[2] + m[13]*v[3];
	vout[2] = m[2]*v[0] + m[6]*v[1] + m[10]*v[2] + m[14]*v[3];
	vout[3] = m[3]*v[0] + m[7]*v[1] + m[11]*v[2] + m[15]*v[3];
}

// multiply 2 matrix

void multiplyMatrixAndMatrix(mat4f_t c, const mat4f_t a, const mat4f_t b)
{
	uint8_t col, row, i;
	memset(c, 0, 16*sizeof(float));
	
	for (col = 0; col < 4; col++) {
		for (row = 0; row < 4; row++) {
			for (i = 0; i < 4; i++) {
				c[col*4+row] += a[i*4+row]*b[col*4+i];
			}
		}
	}
}

// transfrom vector 4 dimensional from vector rotaionMatrix

void transformFromCMRotationMatrix(vec4f_t mout, const CMRotationMatrix *m)
{
	mout[0] = (float)m->m11;
	mout[1] = (float)m->m21;
	mout[2] = (float)m->m31;
	mout[3] = 0.0f;
	
	mout[4] = (float)m->m12;
	mout[5] = (float)m->m22;
	mout[6] = (float)m->m32;
	mout[7] = 0.0f;
	
	mout[8] = (float)m->m13;
	mout[9] = (float)m->m23;
	mout[10] = (float)m->m33;
	mout[11] = 0.0f;
	
	mout[12] = 0.0f;
	mout[13] = 0.0f;
	mout[14] = 0.0f;
	mout[15] = 1.0f;
}

//transfrom coordinates of moon to NUE with azimuth, distance and altitude

void convertToNUE (float azimuth ,float altitude, float distance, float *e, float *n, float *u)
{
    *e = distance * cosf(altitude) * sinf(azimuth-M_PI/2);
    *n = distance * cosf(altitude) * cosf(azimuth-M_PI/2);
    *u = distance * sinf(altitude);
}

@end
