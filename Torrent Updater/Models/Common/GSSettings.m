//
//  GSSettings.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 18/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSSettings.h"

@implementation GSSettings

-(id)init {
    self = [super init];
    if (self) {
        __fileLocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"fileLocation"];
        __autoDownloadWhenUpdated = [[NSUserDefaults standardUserDefaults] objectForKey:@"autoDownloadWhenUpdated"];
        __autoDownloadWhenAdded = [[NSUserDefaults standardUserDefaults] objectForKey:@"autoDownloadWhenAdded"];
        __autoRefreshTimeout = [[NSUserDefaults standardUserDefaults] objectForKey:@"autoRefresh"];
        __previousVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"previousVersion"];
        __lastUpdated = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdated"];
        __menuItem = [[NSUserDefaults standardUserDefaults] objectForKey:@"menuItem"];
        __showDock = [[NSUserDefaults standardUserDefaults] objectForKey:@"showDock"];
        __downloadedFilename = [[NSUserDefaults standardUserDefaults] objectForKey:@"downloadedFilename"];
        __actionsAreEnabled = [[NSUserDefaults standardUserDefaults] objectForKey:@"actionsAreEnabled"];
    }
    return self;
}

+(void)setDefaults {
    NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"defaultPrefs" ofType:@"plist"];
    NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

#pragma mark -
#pragma mark getters    

+(NSDictionary *)getTrackersPlist {
    NSString *trackersPrefsFile = [[NSBundle mainBundle] pathForResource:@"trackers" ofType:@"plist"];
    NSDictionary *trackersDict = [NSDictionary dictionaryWithContentsOfFile:trackersPrefsFile];
    if (!trackersDict)
    {
        NSLog(@"Error reading tracker.plist");
    }
    return trackersDict;
}


+(NSMutableDictionary *)getSettingsForTracker:(NSString *)tracker {
    return [[self getTrackersPlist] objectForKey:tracker];
}

+(NSArray *)getTrackersList {
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"order" ascending: YES];
    NSArray *descriptors = [NSArray arrayWithObjects:sort, nil];
    NSDictionary *trackersPlist = [self getTrackersPlist];
    NSArray *names = [[[trackersPlist allValues] sortedArrayUsingDescriptors:descriptors] valueForKey:@"name"];
    return names;
}




#pragma mark -
#pragma mark setters

+(void)setFileLocation:(NSString *)fileLocation {
    [self writeValue:fileLocation at:@"fileLocation"];
}
+(void)setPreviousVersion:(NSString *)previousVersion {
    [self writeValue:previousVersion at:@"previousVersion"];
}
+(void)setlastUpdated:(NSDate *)lastUpdated {
    [self writeValue:lastUpdated at:@"lastUpdated"];
}
+(void)setShowDock:(NSNumber *)showDock {
    [self writeValue:showDock at:@"showDock"];
}

+(void)setactionsAreEnabled:(NSNumber *)actionsAreEnabled {
    [self writeValue:actionsAreEnabled at:@"actionsAreEnabled"];
}

+(void)writeValue:(id)value at:(NSString *)name {
    [[NSUserDefaults standardUserDefaults]  setObject:value forKey:name];
    [[NSUserDefaults standardUserDefaults]  synchronize];
}


-(void)resetSettings {
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultsDictionary allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}



-(BOOL)checkSettings {
    return YES;
}

@end
