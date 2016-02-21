//
//  PDServerPhotoReport.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"


enum PDServerPhotoReportReason {
	PDServerPhotoReportReasonOffensive = 1,
	PDServerPhotoReportReasonSpam,
	PDServerPhotoReportReasonWrongContent,
	PDServerPhotoReportReasonInaccurateLocation
	};

@interface PDServerPhotoReport : PDServerExchange

- (void)reportAboutPhoto:(PDPhoto *)photo reason:(NSInteger)reason;

@end
