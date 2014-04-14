//
//  GSTimerController.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 20/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GSSettings.h"
#import "GSAppDelegate.h"

@interface GSTimerController : NSObjectController {
    NSTimer *sharedTimer;
}

+(GSTimerController *) sharedInstance;

-(void)startAutoUpdateTimer;
-(void)updateAll;


@end
