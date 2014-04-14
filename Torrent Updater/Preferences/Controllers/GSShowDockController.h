//
//  GSShowDockController.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 18/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GSSettings.h"
#import "GSAppDelegate.h"
#import "GSTorrentsGetter.h"

@interface GSShowDockController : NSObjectController

@property(assign, nonatomic) BOOL showDock;
-(void)changeBadge;
@end
