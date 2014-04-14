//
//  GSAnalytics.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 27/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>

#import "GSTorrentsGetter.h"
#import "GSExtra.h"

@interface GSAnalytics : NSObject

+(void)sendPostWithMessage:(NSString *)message;
+ (void)onStartup;
+ (void)onShutdown;
+ (void)torrentHasBeenAdded;
+ (void)torrentHasBeenRemoved;
+ (void)torrentHasBeenDownloaded;

+ (NSString *)serialNumber;
+ (NSString *)OSVersion;
+ (NSString *)programVersion;

@end
