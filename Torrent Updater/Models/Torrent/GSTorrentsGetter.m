//
//  GSTorrentsGetter.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 21/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSTorrentsGetter.h"

@implementation GSTorrentsGetter


+(NSMutableDictionary *)getDictForTracker:(NSString *)tracker {
    return [[NSUserDefaults standardUserDefaults] objectForKey:tracker];
}

+(NSMutableDictionary *)getDictForTorID:(NSNumber *)TorID atTracker:(NSString *)tracker {
    NSDictionary *trackerDict = [self getDictForTracker:tracker];
    return [trackerDict objectForKey:[NSString stringWithFormat:@"%@", TorID]];
}

+(NSNumber *)countNewTorrents {
    NSMutableArray *newTorrents = [[NSMutableArray alloc] init];
    NSArray *allTorrents = [self getAllTorrents];
    [allTorrents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       if ([[obj objectForKey:@"new"] isEqual: @(YES)])
           [newTorrents addObject:obj];
    }];
    return [NSNumber numberWithInteger: [newTorrents count]];
}

+(NSArray *)getAllTorrents {
    NSMutableArray *torrents = [[NSMutableArray alloc] init];
    NSArray *trackers = [GSSettings getTrackersList];
    [trackers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"modified" ascending: YES];
        NSArray *descriptors = [NSArray arrayWithObjects:sort, nil];
        NSArray *torrentsOfThisTracker = [[[self getDictForTracker:obj] allValues] sortedArrayUsingDescriptors:descriptors];
        [torrents addObjectsFromArray:torrentsOfThisTracker];
    }];
    return torrents;
}
@end
