//
//  PDItem.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDItem.h"

@interface PDItem (Private) 
@end

@implementation PDItem

- (void)setFullImageURL:(NSURL *)fullImageURL
{
	if ([fullImageURL isKindOfClass:[NSString class]]) {
		_fullImageURL = [NSURL URLWithString:(NSString *)fullImageURL];
	} else {
		_fullImageURL = fullImageURL;
	}
}

- (void)setThumbnailURL:(NSURL *)thumbnailURL
{
	if ([thumbnailURL isKindOfClass:[NSString class]]) {
		_thumbnailURL = [NSURL URLWithString:(NSString *)thumbnailURL];
	} else {
		_thumbnailURL = thumbnailURL;
	}
}

- (void)setValuesFromArray:(NSArray *)array
{
	for (NSDictionary *value in array) {
		NSString *key = [value objectForKey:@"key"];
		SEL selector = NSSelectorFromString(key);
		if ([self respondsToSelector:selector]) {
			[self setValue:[value objectForKey:@"value"] forKey:key];
		}
	}
}

- (void)loadFullDataFromDictionary:(NSDictionary *)dictionary
{
	
}

- (void)loadShortDataFromDictionary:(NSDictionary *)dictionary
{
	
}

- (UIImage *)cachedThumbnailImage
{
	return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.thumbnailURL.absoluteString];
}

- (UIImage *)cachedImage
{
	UIImage *image = self.cachedFullImage;
	if (!image) {
		image = self.cachedThumbnailImage;
	}
	return image;
}

- (UIImage *)cachedFullImage
{
	return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.fullImageURL.absoluteString];
}

- (NSString *)textForShare
{
	return [NSString stringWithFormat:@"%@", self.thumbnailURL];
}

- (NSString *)countValueInString:(NSInteger)value
{
	if (value > 999999) {
		return [NSString stringWithFormat:@"%zdm", value / 1000000];
	} else if (value > 999) {
		return [NSString stringWithFormat:@"%zdk", value / 1000];
	} else if (value == 0) {
		return @"0";
	} else {
		return [NSString stringWithFormat:@"%ld", (long)value];
	}
}

- (void)itemWasSelected
{
	if ([self.itemDelegate respondsToSelector:@selector(itemDidSelect:)]) {
		[self.itemDelegate itemDidSelect:self];
	}
}

- (BOOL)isEqual:(id)object
{
	if (![object isKindOfClass:[self class]]) return NO;
	
	return ([(PDItem *) object identifier] == [self identifier]);
}

- (NSString *)followItemName
{
	NSLog(@"No follow item name for %@", self);
	return @"";
}

@end
