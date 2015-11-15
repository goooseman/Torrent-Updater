//
//  GSExtra.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 21/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSExtra.h"

@implementation GSExtra

static GSExtra *_sharedInstance = nil;


+ (GSExtra *) sharedInstance {
    @synchronized(self) {
        if (!_sharedInstance) {
            _sharedInstance = [[GSExtra alloc] init];
        }
    }
    return _sharedInstance;
}





+(void)showError:(NSString *)errorMessage {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSAlert alertWithMessageText:errorMessage defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
    });
    
}

+(void)showError:(NSString *)errorMessage withInformativeMessage:(NSString *)informativeMessage {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSAlert alertWithMessageText:errorMessage defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", informativeMessage] runModal];
    });

}

+(void)openInSafari:(NSString *)link {
    system([[NSString stringWithFormat:@"open -a Safari %@", link] cStringUsingEncoding:NSASCIIStringEncoding]);
    
}

+(void)openInDefaultBrowser:(NSString *)link {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:link]];
}

-(NSOperationQueue *)sharedOperationQueue {
    if (!operationQueue)
        operationQueue = [[NSOperationQueue alloc] init];
    return operationQueue;
}

+(BOOL)checkInternet {
    NSString *dataString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://google.com"] encoding:NSWindowsCP1251StringEncoding error:nil];
    
    if (dataString && [dataString containsString:@"google"])
        return YES;
    else {
        
        return NO;
    }
    
}

-(BOOL)checkInternetAndShowError {
    NSLog(@"Checking Internet");
    NSString *dataString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://google.com"] encoding:NSWindowsCP1251StringEncoding error:nil];

    if (dataString && [dataString containsString:@"google"]) {
        return YES;
    } else {
        
        [[[NSApplication sharedApplication] delegate] performSelector:@selector(stopLoadingIndicatorWithMessage:) withObject:NSLocalizedString(@"No Internet Connection", nil)];
        return NO;
    }
}


-(BOOL)checkLoginAndShowErrorForTracker:(NSString *)tracker {
    if ([GSTorrCheck loginCorrectAtTracker:tracker]) {
        loginFailedErrorHasBeenAlerted = NO;
        return YES;
    } else {
        if (!loginFailedErrorHasBeenAlerted) {
            loginFailedErrorHasBeenAlerted = YES;
            NSLog(@"Login failed for tracker: %@", tracker);
            [[[NSApplication sharedApplication] delegate] performSelector:@selector(stopLoadingIndicatorWithMessage:) withObject:[NSString stringWithFormat:NSLocalizedString(@"Login Failed", nil), tracker]];
        }
        return NO;
    }
    
}


@end
