//
//  GSShowDockController.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 18/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSShowDockController.h"
#import "GSAppDelegate.h"

@implementation GSShowDockController



-(BOOL) getShowDock {
    return [[[GSSettings alloc] init]._showDock boolValue];
}

-(void) setShowDock:(BOOL)enabled {
    if (enabled == 1) {
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        [self changeBadge];
    } else {
        [NSApp setActivationPolicy: NSApplicationActivationPolicyAccessory];
        [[GSAppDelegate alloc] performSelector:@selector(showAppSel:) withObject:NULL afterDelay:0.05];
    }
    [GSSettings setShowDock:[NSNumber numberWithBool:enabled]];
    
}

-(void)changeBadge {
    NSDockTile *tile = [[NSApplication sharedApplication] dockTile];

    if ([[GSTorrentsGetter countNewTorrents] integerValue] > 0 && [[[GSSettings alloc] init]._showDock boolValue] == true) {
        [tile setBadgeLabel:[NSString stringWithFormat:@"%@", [GSTorrentsGetter countNewTorrents]]];
    } else {
        [tile setBadgeLabel:@""];
    }
    
    
}

@end
