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
    NSMutableDictionary *trackerSettDict = [GSSettings getSettingsForTracker:tracker];
    if ([[trackerSettDict objectForKey:@"needLogin"] isEqualTo:@(NO)])
        return YES;
    NSError *error;
    NSString *html;
    
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
