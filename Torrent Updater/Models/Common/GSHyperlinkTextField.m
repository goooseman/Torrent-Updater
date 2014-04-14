//
//  GSHyperlinkTextField.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 29/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSHyperlinkTextField.h"

@implementation GSHyperlinkTextField

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (void)resetCursorRects {
    [self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
}

-(void)setHyperlinkTextFieldWithText:(NSString *)text andLink:(NSString *)link {
    [self setSelectable:YES];
    [self setAttributedStringValue:[NSAttributedString hyperlinkFromString:text withURL:[NSURL URLWithString:link]]];
}

@end
