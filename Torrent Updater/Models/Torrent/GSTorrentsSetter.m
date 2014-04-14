//
//  GSTorrentsSetter.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 21/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSTorrentsSetter.h"

@implementation GSTorrentsSetter

+(void)writeValue:(id)value at:(NSString *)name atTracker:(NSString *)tracker {
    NSMutableDictionary *trackerDict = [[GSTorrentsGetter getDictForTracker:tracker] mutableCopy];
    if (!trackerDict) trackerDict = [[NSMutableDictionary alloc] init];
    [trackerDict setObject:value forKey:name];
    [[NSUserDefaults standardUserDefaults] setObject:trackerDict forKey:tracker];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)writeValue:(id)value at:(NSString *)name forTorID:(NSNumber *)TorID atTracker:(NSString *)tracker {
    NSMutableDictionary *torDict = [[GSTorrentsGetter getDictForTorID:TorID atTracker:tracker] mutableCopy];
    NSMutableDictionary *trackerDict = [[GSTorrentsGetter getDictForTracker:tracker] mutableCopy];
    if (!torDict) torDict = [[NSMutableDictionary alloc] init];
    if (!trackerDict) trackerDict = [[NSMutableDictionary alloc] init];
    [torDict setObject:value forKey:name];
    [trackerDict setObject:torDict forKey:[NSString stringWithFormat:@"%@",TorID]];
    [[NSUserDefaults standardUserDefaults] setObject:trackerDict forKey:tracker];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)changeTorrentID:(NSNumber *)TorID title:(NSString *)title modifiedAt:(NSDate *)modified maybeNew:(BOOL)maybeNew atTracker:(NSString *)tracker {
    NSMutableDictionary *torDict = [[GSTorrentsGetter getDictForTorID:TorID atTracker:tracker] mutableCopy];
    if (!torDict) torDict = [[NSMutableDictionary alloc] init];
    [torDict setObject:[NSString stringWithFormat:@"%@", TorID] forKey:@"ID"];
    if (title) [torDict setObject:title forKey:@"title"];
    if (modified) [torDict setObject:modified forKey:@"modified"];
    [torDict setObject:[[NSDate alloc] init] forKey:@"updated"];
    [torDict setObject:tracker forKey:@"tracker"];
    if (maybeNew) [torDict setObject:[NSNumber numberWithBool:maybeNew] forKey:@"new"];
    
    [self writeValue:torDict at:[NSString stringWithFormat:@"%@", TorID] atTracker:tracker];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)removeTorrentID:(NSNumber *)TorID atTracker:(NSString *)tracker {
    NSMutableDictionary *trackerDict = [[GSTorrentsGetter getDictForTracker:tracker] mutableCopy];
    [trackerDict removeObjectForKey:[NSString stringWithFormat:@"%@", TorID]];
    [[NSUserDefaults standardUserDefaults] setObject:trackerDict forKey:tracker];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [GSAnalytics torrentHasBeenRemoved];
}


@end
