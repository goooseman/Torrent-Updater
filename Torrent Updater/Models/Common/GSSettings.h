//
//  GSSettings.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 18/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSSettings : NSObject

@property (readonly) NSString *_fileLocation;
@property (readwrite, nonatomic, copy) NSNumber *_autoRefreshTimeout;
@property (readonly) NSDate *_lastUpdated;
@property (readonly) NSNumber *_autoDownloadWhenUpdated;
@property (readonly) NSNumber *_autoDownloadWhenAdded;
@property (readonly) NSString *_previousVersion;
@property (readonly) NSNumber *_menuItem;
@property (readonly) NSNumber *_showDock;
@property (readonly) NSNumber *_downloadedFilename;
@property (readonly) NSNumber *_actionsAreEnabled;



-(id)init;
+(void)setDefaults;

+(NSDictionary *)getTrackersPlist;
+(NSMutableDictionary *)getSettingsForTracker:(NSString *)tracker;
+(NSArray *)getTrackersList;

+(void)setFileLocation:(NSString *)fileLocation;
+(void)setPreviousVersion:(NSString *)previousVersion;
+(void)setlastUpdated:(NSDate *)lastUpdated;
+(void)setShowDock:(NSNumber *)showDock;
+(void)setactionsAreEnabled:(NSNumber *)actionsAreEnabled;




-(void)resetSettings;
-(BOOL)checkSettings;

@end


