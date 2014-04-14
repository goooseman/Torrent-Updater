//
//  GSTorrentsGetter.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 21/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSSettings.h"

@interface GSTorrentsGetter : NSObject

+(NSMutableDictionary *)getDictForTracker:(NSString *)tracker;
+(NSMutableDictionary *)getDictForTorID:(NSNumber *)TorID atTracker:(NSString *)tracker;

+(NSNumber *)countNewTorrents;
+(NSArray *)getAllTorrents;
@end
