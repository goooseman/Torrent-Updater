//
//  GSTorrDownload.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 22/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSTorrDownload.h"

@implementation GSTorrDownload

-(void)downloadTorrWithNumber:(NSNumber *)torID atTracker:(NSString *)tracker {
    GSSettings *settings = [[GSSettings alloc] init];
    NSDictionary *trackerSettDict = [GSSettings getSettingsForTracker:tracker];
    NSURL *torrentUrl = [NSURL URLWithString:[NSString stringWithFormat:[trackerSettDict objectForKey:@"downloadURL"], torID]];
    NSString *filename;
    
    switch([settings._downloadedFilename integerValue]) {
            case 0:
                break;
            case 1:
                filename = [NSString stringWithFormat:@"[%@] %@.torrent", tracker, torID];
                break;
            case 2:
            
                filename = [NSString stringWithFormat:@"[%@] %@.torrent", tracker, [[[GSTorrentsGetter getDictForTorID:torID atTracker:tracker] objectForKey:@"title"] getSubstringUntil:[[GSSettings getSettingsForTracker:tracker] objectForKey:@"titleSeparator"]]];
                break;
            
    }
   
   
    NSString *path = [[[GSSettings alloc] init]._fileLocation stringByExpandingTildeInPath];
    
    NSMutableURLRequest *torrRequest = [NSMutableURLRequest requestWithURL:torrentUrl];
    if ([tracker isEqualTo:@"RuTracker.org"]) {
        NSString *torrPost = [NSString stringWithFormat:@"t=%@", torID];
        NSData *torrPostData = [torrPost dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        [torrRequest setValue:[NSString stringWithFormat:@"%ld",[torrPostData length]] forHTTPHeaderField:@"Content-Length"];
        [torrRequest setHTTPBody:torrPostData];
        [torrRequest setHTTPMethod:@"POST"]; 
    }

    [torrRequest setHTTPShouldHandleCookies:YES];
    [torrRequest setValue:[NSString stringWithFormat:@"%@%@", [trackerSettDict objectForKey:@"torrentUrl"] ,torID] forHTTPHeaderField:@"Referer"];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURLDownload  *torrDownload = [[NSURLDownload alloc] initWithRequest:torrRequest delegate:self];
        
        if (!torrDownload) {
            NSLog(@"Failed");
        } else if (filename.length > 0) {
            [torrDownload setDestination:[path stringByAppendingPathComponent:filename] allowOverwrite:YES];
        }
    });
}

- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename {
    NSString *path = [[[GSSettings alloc] init]._fileLocation stringByExpandingTildeInPath];
    [download setDestination:[path stringByAppendingPathComponent:filename] allowOverwrite:YES];
}


- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error {
    NSLog(@"Download failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)downloadDidFinish:(NSURLDownload *)download {
    [GSAnalytics torrentHasBeenDownloaded];
}

@end
