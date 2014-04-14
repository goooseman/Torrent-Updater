//
//  GSTorrentsSetter.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 21/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSSettings.h"
#import "GSAnalytics.h"
#import "GSTorrentsGetter.h"

@interface GSTorrentsSetter : NSObject

+(void)writeValue:(id)value at:(NSString *)name atTracker:(NSString *)tracker;
+(void)writeValue:(id)value at:(NSString *)name forTorID:(NSNumber *)TorID atTracker:(NSString *)tracker;
+(void)changeTorrentID:(NSNumber *)TorID title:(NSString *)title modifiedAt:(NSDate *)modified maybeNew:(BOOL)maybeNew atTracker:(NSString *)tracker;
+(void)removeTorrentID:(NSNumber *)TorID atTracker:(NSString *)tracker;

@end
