//
//  GSTorrUpdate.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 22/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSTorrUpdate.h"

@implementation GSTorrUpdate

+(void)updateTorrWithNumber:(NSNumber *)torID atTracker:(NSString *)tracker {
    if (![[GSExtra sharedInstance] checkInternetAndShowError]) {
        return;
    }
    if (![[GSExtra sharedInstance] checkLoginAndShowErrorForTracker:tracker]) {
        return;
    }
    
    NSDictionary *torrDict = [GSTorrentsGetter getDictForTorID:torID atTracker:tracker];
    NSDictionary *trackerSettDict = [GSSettings getSettingsForTracker:tracker];

    NSError *error = nil;
    NSString *html;
    if ([[trackerSettDict objectForKey:@"encoding"] isEqual: @"UTF8"])
        html = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[trackerSettDict objectForKey:@"torrentUrl"], torID]] encoding: NSUTF8StringEncoding error:&error];
    else
        html = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[trackerSettDict objectForKey:@"torrentUrl"], torID]] encoding: NSWindowsCP1251StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    if (!html) {
        NSLog(@"Strange problem");
        return;
    }
    
    if(![html containsString:[trackerSettDict objectForKey:@"checkTorrent"]]) {
        NSLog(@"Strange problem at tracker: %@", tracker);
        return;
    }

    NSString *modified = [html getSubstringBetween:[trackerSettDict objectForKey:@"modifiedParseStart"] and:[trackerSettDict objectForKey:@"modifiedParseEnd"]];
    
    // Kinozal.tv Special Start
    if (!modified && [tracker isEqual: @"Kinozal.tv"]) {
        modified = [html getSubstringBetween:@"<li>Обновлен<span class=\"floatright green n\">" and:@"</span></li>\n</ul>"];
    }
    if (!modified && [tracker isEqual: @"Kinozal.tv"]) {
        modified = [html getSubstringBetween:@"Залит<span class=\"floatright green n\">" and:@"</span></li>\n</ul>"];
        
    }
    if ([modified containsString:@"сегодня"] && [tracker isEqual: @"Kinozal.tv"]) {
        NSDateFormatter *todayDateFormatter = [[NSDateFormatter alloc] init];
        [todayDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
        [todayDateFormatter setDateFormat:@"dd MMMM yyyy"];
        
        modified = [modified stringByReplacingOccurrencesOfString:@"сегодня" withString:[todayDateFormatter stringFromDate:[NSDate date]]];
    }
    
    if ([modified containsString:@"сейчас"] && [tracker isEqual: @"Kinozal.tv"]) {
        NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
        [nowDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
        [nowDateFormatter setDateFormat:@"dd MMMM yyyy 'в' HH:mm"];
        
        modified = [modified stringByReplacingOccurrencesOfString:@"сегодня" withString:[nowDateFormatter stringFromDate:[NSDate date]]];
    }
    
    if ([modified containsString:@"вчера"] && [tracker isEqual: @"Kinozal.tv"]) {
        NSDateFormatter *yesterdayDateFormatter = [[NSDateFormatter alloc] init];
        [yesterdayDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
        [yesterdayDateFormatter setDateFormat:@"dd MMMM yyyy"];
        modified = [modified stringByReplacingOccurrencesOfString:@"вчера" withString:[yesterdayDateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval: -86400.0]]];
    }
    // Kinozal.tv Special End
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    [df setDateFormat:[trackerSettDict objectForKey:@"dateFormat"]];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [df setShortMonthSymbols:[trackerSettDict objectForKey:@"monthsNames"]];
    NSDate *date = [df dateFromString:modified];
    if (!date) {
        NSLog(@"Can't parse date: %@ for TorID: %@ at tracker: %@", modified, torID, tracker);
        return;
    }
    if (date != [torrDict objectForKey:@"modified"]) {
        NSString *title = [[html getSubstringBetween:[trackerSettDict objectForKey:@"titleParseStart"] and:[trackerSettDict objectForKey:@"titleParseEnd"]] stringByReplacingOccurrencesOfString:[trackerSettDict objectForKey:@"removeInTitle"] withString:@""];
        [GSTorrentsSetter changeTorrentID:torID title:title modifiedAt:date maybeNew:YES atTracker:tracker];
        NSUserNotificationCenter *nc = [NSUserNotificationCenter defaultUserNotificationCenter];
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = NSLocalizedString(@"Notification: Torrent Updated", nil);
        notification.subtitle = [torrDict objectForKey:@"title"];
        [nc deliverNotification:notification];
        if ([[[GSSettings alloc] init]._autoDownloadWhenUpdated isEqual:@(YES)]) {
            [[[GSTorrDownload alloc] init] downloadTorrWithNumber:torID atTracker:tracker];
        }
    } else {
        [GSTorrentsSetter changeTorrentID:torID title:nil modifiedAt:nil maybeNew:NO atTracker:tracker];

    }
}

+(void)updateAllTorrents {
    [[GSTorrentsGetter getAllTorrents] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self updateTorrWithNumber:[obj objectForKey:@"ID"] atTracker:[obj objectForKey:@"tracker"]];
    }];
    [GSSettings setlastUpdated:[[NSDate alloc] init]];
}

+(void)stopLoadingIndicatorWithMessage:(NSString *)message {
    
}
@end
