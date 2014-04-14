//
//  GSTorrAdd.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 21/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSTorrAdd.h"

@implementation GSTorrAdd

+(void)addTorrWithNumber:(NSNumber *)torID atTracker:(NSString *)tracker {
    if (![[GSExtra sharedInstance] checkInternetAndShowError]) {
        return;
    }
    NSDictionary *trackerSettDict = [GSSettings getSettingsForTracker:tracker];
    NSDictionary *trackerDict = [GSTorrentsGetter getDictForTracker:tracker];
    if ([[trackerDict allKeys] containsObject:[torID stringValue]]) {
        NSLog(@"Dublicate torrent #%@ at %@", torID, tracker);
        [GSExtra showError:NSLocalizedString(@"Dublicate Torrent", nil)];
        return;
    }
    NSError *error = nil;
    NSString *html;
    if ([[trackerSettDict objectForKey:@"encoding"] isEqual: @"UTF8"])
        html = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[trackerSettDict objectForKey:@"torrentUrl"], torID]] encoding: NSUTF8StringEncoding error:&error];
    else
        html = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[trackerSettDict objectForKey:@"torrentUrl"], torID]] encoding: NSWindowsCP1251StringEncoding error:&error];

    if (error) {
        NSLog(@"%@", error);
    }
    
    if (!html) {
        NSLog(@"Strange problem");
        return;
    }
    
    if(![html containsString:[trackerSettDict objectForKey:@"checkTorrent"]]) {
        NSLog(@"Wrong torrent number");
        [GSExtra showError:NSLocalizedString(@"Wrong Torrent Number", nil)];
        return;
    }
    NSString *title = [[html getSubstringBetween:[trackerSettDict objectForKey:@"titleParseStart"] and:[trackerSettDict objectForKey:@"titleParseEnd"]] stringByReplacingOccurrencesOfString:[trackerSettDict objectForKey:@"removeInTitle"] withString:@""];
    NSString *modified = [html getSubstringBetween:[trackerSettDict objectForKey:@"modifiedParseStart"] and:[trackerSettDict objectForKey:@"modifiedParseEnd"]];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    [df setDateFormat:[trackerSettDict objectForKey:@"dateFormat"]];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [df setShortMonthSymbols:[trackerSettDict objectForKey:@"monthsNames"]];
    
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
    
    if ([modified containsString:@"вчера"] && [tracker isEqual: @"Kinozal.tv"]) {
        NSDateFormatter *yesterdayDateFormatter = [[NSDateFormatter alloc] init];
        [yesterdayDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
        [yesterdayDateFormatter setDateFormat:@"dd MMMM yyyy"];
        modified = [modified stringByReplacingOccurrencesOfString:@"вчера" withString:[yesterdayDateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval: -86400.0]]];
    }
    // Kinozal.tv Special End
    
    NSDate *date = [df dateFromString:modified];
    
    if (date && title) {
        
        [GSTorrentsSetter changeTorrentID:torID title:title modifiedAt:date maybeNew:NO atTracker:tracker];
    } else {
        [GSExtra showError:NSLocalizedString(@"Something Went Wrong", nil)];
        NSLog(@"Something went wrong. TorID: %@ at tracker: %@. Title: %@, date: %@, parsedDate: %@, %@", torID, tracker, title, modified, date, html);
        return;
    }
    if ([[[GSSettings alloc] init]._autoDownloadWhenAdded isEqual:@(YES)]) {
        [[[GSTorrDownload alloc] init] downloadTorrWithNumber:torID atTracker:tracker];
    }
    [GSAnalytics torrentHasBeenAdded];
    
    
    
}




@end
