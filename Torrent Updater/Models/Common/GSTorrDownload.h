//
//  GSTorrDownload.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 22/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSSettings.h"
#import "GSTorrentsGetter.h"
#import "GSExtra.h"

@interface GSTorrDownload : NSObject <NSURLDownloadDelegate>

-(void)downloadTorrWithNumber:(NSNumber *)torID atTracker:(NSString *)tracker;

@end
