//
//  MGTemplateEngineTest.h
//  MGTemplateEngine
//
//  Created by Robert Bowdidge on 5/22/12.
//  Copyright 2012 Robert Bowdidge. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MGTemplateEngine.h"

@interface TemplateEngineTestDelegate : NSObject<MGTemplateEngineDelegate> {
	NSString *lastError_;
}
- (NSString*) lastError;
- (void)templateEngine:(MGTemplateEngine *)engine encounteredError:(NSError *)error isContinuing:(BOOL)continuing;
@end


@interface MGTemplateEngineTest : XCTestCase {
	MGTemplateEngine *engine_;
	TemplateEngineTestDelegate *delegate_;
}

@end
