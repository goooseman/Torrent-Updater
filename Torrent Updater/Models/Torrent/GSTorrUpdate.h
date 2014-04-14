//
//  GSTorrUpdate.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 22/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSTorrentsGetter.h"
#import "GSTorrentsSetter.h"
#import "GSSettings.h"
#import "GSExtra.h"
#import "GSAppDelegate.h"
#import "GSTorrUpdate.h"

@interface GSTorrUpdate : NSObject <NSUserNotificationCenterDelegate>

@property (weak) IBOutlet NSTextField *lastUpdatedLabel;

+(void)updateTorrWithNumber:(NSNumber *)torID atTracker:(NSString *)tracker;
+(void)updateAllTorrents;

@end
