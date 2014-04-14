//
//  GSTimerController.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 20/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSTimerController.h"

@implementation GSTimerController
static GSTimerController *_sharedInstance = nil;

+ (GSTimerController *) sharedInstance {
    @synchronized(self) {
        if (!_sharedInstance) {
            _sharedInstance = [[GSTimerController alloc] init];
        }
    }
    return _sharedInstance;
}

-(void)startAutoUpdateTimer {
    double timeout = [[[GSSettings alloc] init]._autoRefreshTimeout doubleValue];
    if (sharedTimer)
        [sharedTimer invalidate];
    if (timeout != 0)
        [[NSProcessInfo processInfo] performActivityWithOptions:NSActivityAutomaticTerminationDisabled reason:@"Prevent App Nap" usingBlock:^{
            sharedTimer = [NSTimer scheduledTimerWithTimeInterval:timeout * 60 target:self selector:@selector(updateAll) userInfo:nil repeats:YES];
        }];
    
}

-(void)updateAll {
    NSLog(@"Updating by timer!");
    [[[NSApplication sharedApplication] delegate] performSelector:@selector(updateAllSel:) withObject:nil];
    
}

@end
