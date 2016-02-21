//
//  LTTSingleton.m
//  Pashadelic
//
//  Created by TungNT2 on 3/20/14.
//
//

#import "LTTSingleton.h"

@implementation LTTSingleton

static NSMutableDictionary *_shareInstances = nil;

+ (id)sharedInstance
{
    @synchronized(self) {
        if (!_shareInstances) _shareInstances = [[NSMutableDictionary alloc] initWithCapacity:0];//add
        if (![_shareInstances objectForKey:[[self class] description]]) {//add 4 lines
            id singletonObject = [[self alloc] init];
            [_shareInstances setObject:singletonObject forKey:[[self class] description]];
        }
    }
    return [_shareInstances objectForKey:[[self class] description]];//add
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        id sharedInstance = [_shareInstances objectForKey:[[self class] description]];//add
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

@end
