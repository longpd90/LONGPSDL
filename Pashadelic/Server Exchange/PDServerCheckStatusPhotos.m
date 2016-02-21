

//
//  PDServerCheckStatusPhotos.m
//  Pashadelic
//
//  Created by LongPD on 8/1/14.
//
//

#import "PDServerCheckStatusPhotos.h"

@implementation PDServerCheckStatusPhotos

- (void)checkStatusListPhotos:(NSArray *)photos
{
    self.functionPath = [NSString stringWithFormat:@"/photos/status.json?photo_ids="];
    NSMutableString *request = [[NSMutableString alloc] init];
    for (int i = 0; i < photos.count; i ++) {
        PDPhoto *photo = (PDPhoto *)[photos objectAtIndex:i];
        [request appendString:[NSString stringWithFormat:@"%ld,", (long)photo.identifier]];
    }

    [self requestToGetFunctionWithString:request];
}

@end
