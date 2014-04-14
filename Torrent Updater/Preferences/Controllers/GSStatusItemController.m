//
//  GSStatusItemController.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 20/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSStatusItemController.h"

@implementation GSStatusItemController
static GSStatusItemController *_sharedInstance = nil;


+ (GSStatusItemController *) sharedInstance {
    @synchronized(self) {
        if (!_sharedInstance) {
            _sharedInstance = [[GSStatusItemController alloc] init];
        }
    }
    return _sharedInstance;
}

-(void)setMenuItem:(BOOL)enabled withMenu:(NSMenu*)menu {
    myStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    if (menu != nil) {
        myStatusMenu = menu;
    }
    if (enabled == 1) {
        
        if ([[GSTorrentsGetter countNewTorrents] integerValue] > 0)
            [myStatusItem setImage:[NSImage imageNamed:@"status_item_unread_icon"]];
        else
            [myStatusItem setImage:[NSImage imageNamed:@"status_item_icon"]];
        [myStatusItem setAlternateImage:[NSImage imageNamed:@"status_item_click_icon"]];
        [myStatusItem setHighlightMode:YES];
        [myStatusItem setMenu:myStatusMenu];
    } else {
        [[NSStatusBar systemStatusBar] removeStatusItem:myStatusItem];
    }
}

-(void)changeIcon {
    if ([[GSTorrentsGetter countNewTorrents] integerValue] > 0)
        [myStatusItem setImage:[NSImage imageNamed:@"status_item_unread_icon"]];
    else
        [myStatusItem setImage:[NSImage imageNamed:@"status_item_icon"]];
}
@end
