//
//  GSHyperlinkTextField.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 29/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GSAdditions.h"

@interface GSHyperlinkTextField : NSTextField

-(void)setHyperlinkTextFieldWithText:(NSString *)text andLink:(NSString *)link;

@end
