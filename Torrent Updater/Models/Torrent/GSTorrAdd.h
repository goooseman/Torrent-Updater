//
//  GSTorrAdd.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 21/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSSettings.h"
#import "GSExtra.h"
#import "GSTorrentsGetter.h"
#import "GSTorrentsSetter.h"
#import "GSTorrDownload.h"

@interface GSTorrAdd : NSObject

+(void)addTorrWithNumber:(NSNumber *)torID atTracker:(NSString *)tracker;

@end
