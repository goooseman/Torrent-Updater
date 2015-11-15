//
//  GSTorrCheck.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 20/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSTorrCheck.h"

@implementation GSTorrCheck

+(BOOL)loginCorrectAtTracker: (NSString *)tracker {
    // In El Capitain everything is fucked up. Apps uses their own cookie storage instead of using Safari ones. I'm not a Cocoa developer, so I developed this dirty hack. If the system is El Capitain or highier is copies Safari's cookies to app's ones.
    if (NSAppKitVersionNumber > NSAppKitVersionNumber10_10_Max) {
        NSLog(@"El Capitain!");
    
        NSArray* cookies = [[NSHTTPCookieStorage sharedCookieStorageForGroupContainerIdentifier:@"Cookies"] cookiesForURL:[NSURL URLWithString:@"http://rutracker.org/forum/index.php"]];
        for (NSHTTPCookie* cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
        
        cookies = [[NSHTTPCookieStorage sharedCookieStorageForGroupContainerIdentifier:@"Cookies"] cookiesForURL:[NSURL URLWithString:@"http://kinozal.tv"]];
        for (NSHTTPCookie* cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    
    
    NSMutableDictionary *trackerSettDict = [GSSettings getSettingsForTracker:tracker];
    if ([[trackerSettDict objectForKey:@"needLogin"] isEqualTo:@(NO)])
        return YES;
    NSError *error;
    NSString *html;
    
    [NSHTTPCookieStorage sharedCookieStorageForGroupContainerIdentifier:@"Cookies"];
    
    if ([[trackerSettDict objectForKey:@"encoding"] isEqual: @"UTF8"])
        html = [NSString stringWithContentsOfURL:[NSURL URLWithString: [trackerSettDict objectForKey:@"loginCheckURL"]] encoding: NSUTF8StringEncoding error:&error];
    else
        html = [NSString stringWithContentsOfURL:[NSURL URLWithString: [trackerSettDict objectForKey:@"loginCheckURL"]] encoding: NSWindowsCP1251StringEncoding error:&error];

    if (error) {
        NSLog(@"%@", error);
        return YES;
    }
    
    
    if (html){
        if ([html containsString:[trackerSettDict objectForKey:@"loginCheckString"]]) {
            return YES;
        } else {
            NSLog(@"%@: Login failed", tracker);
            return NO;
        }
    } else {
        return YES;
    }
    
}

@end
