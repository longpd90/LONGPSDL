//
//  PDServerLandmarkLoader.m
//  Pashadelic
//
//  Created by TungNT2 on 7/23/13.
//
//

#import "PDServerLandmarkLoader.h"

@implementation PDServerLandmarkLoader

- (void)loadLandmarkWithLongitude:(double)longitude latitude:(double)latitude range:(float)range page:(NSInteger)page
{
    self.functionPath = @"gtags/near.json";
    [self requestToGetFunctionWithString:[NSString stringWithFormat:@"?lat=%f&lon=%f&range=%f&page=%zd", latitude, longitude, range, page]];
}

@end
