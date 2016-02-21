//
//  PDEditPhotoViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 3/10/12.
//
//

#import "PDUploadPhotoViewController.h"
#import "PDServerEditPhoto.h"

@interface PDEditPhotoViewController : PDUploadPhotoViewController <MGServerExchangeDelegate>

- (BOOL)validateData;

@end
