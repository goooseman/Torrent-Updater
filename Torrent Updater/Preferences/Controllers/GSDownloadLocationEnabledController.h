//
//  GSDownloadLocationEnabledController.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 24/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GSSettings.h"

@interface GSDownloadLocationEnabledController : NSObjectController {
    BOOL new;
}

@property(assign, nonatomic) BOOL downloadLocationEnabled;
@property(weak) IBOutlet NSButton *setLocationButton;
@property(weak) IBOutlet NSPopUpButton *setDownloadFilename;

- (IBAction)update:(id)sender;

@end
