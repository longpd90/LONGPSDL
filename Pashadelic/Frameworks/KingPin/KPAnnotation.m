//
// Copyright 2012 Bryan Bonczek
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "KPAnnotation.h"

@interface KPAnnotation ()

@property (nonatomic, readwrite) NSSet *annotations;
@property (nonatomic, readwrite) float radius;
@end

@implementation KPAnnotation


- (id)initWithAnnotations:(NSArray *)annotations {
    return [self initWithAnnotationSet:[NSSet setWithArray:annotations]];
}

- (id)initWithAnnotationSet:(NSSet *)set {
    self = [super init];
    
    if(self){
        self.annotations = set;
        self.title = [NSString stringWithFormat:@"%lu photos", (unsigned long)[self.annotations count]];
        [self calculateValues];
        KPAnnotation *photoAnnotation = [[self.annotations allObjects] firstObject];
        [self setPhoto:photoAnnotation.photo];
        [self setLandmark:photoAnnotation.landmark];
    }
    
    return self;
}

- (BOOL)isCluster {
    return (self.annotations.count > 1);
}

#pragma mark - Private

- (void)setPhoto:(PDPhoto *)photo
{
    _photo = photo;
}

- (void)setLandmark:(PDPhotoLandMarkItem *)landmark
{
    _landmark = landmark;
}

- (void)calculateValues {
    
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLng = 180;
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLng = -180;
    CLLocationDegrees totalLat = 0;
    CLLocationDegrees totalLng = 0;
    
    for(id<MKAnnotation> a in self.annotations){
        
        CLLocationDegrees lat = [a coordinate].latitude;
        CLLocationDegrees lng = [a coordinate].longitude;
        
        minLat = MIN(minLat, lat);
        minLng = MIN(minLng, lng);
        maxLat = MAX(maxLat, lat);
        maxLng = MAX(maxLng, lng);
        
        totalLat += lat;
        totalLng += lng;
    }
    self.coordinate = CLLocationCoordinate2DMake((minLat + maxLat) / 2,
                                                 (minLng +maxLng) / 2);
    
    self.radius = [[[CLLocation alloc] initWithLatitude:minLat
                                              longitude:minLng]
                   distanceFromLocation:[[CLLocation alloc] initWithLatitude:maxLat
                                                                   longitude:maxLng]] / 2.f;
}

@end
