//
//  GSStatusItemController.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 20/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GSSettings.h"
#import "GSTorrentsGetter.h"

@interface GSStatusItemController : NSObjectController {
    NSStatusItem *myStatusItem;
    NSMenu *myStatusMenu;
}

+(GSStatusItemController *) sharedInstance;
-(void)setMenuItem:(BOOL)enabled withMenu:(NSMenu*)menu;
-(void)changeIcon;
@end
