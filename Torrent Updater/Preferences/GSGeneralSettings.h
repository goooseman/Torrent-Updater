//
//  GSGeneralSettings.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 18/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"
#import "GSSettings.h"
#import "GSAppDelegate.h"
#import "GSTimerController.h"

@interface GSGeneralSettings : NSViewController <MASPreferencesViewController>



- (IBAction)autoRefreshSel:(id)sender;
- (IBAction)menuBarItemSel:(id)sender;
- (IBAction)selectFolderSel:(id)sender;




@end
