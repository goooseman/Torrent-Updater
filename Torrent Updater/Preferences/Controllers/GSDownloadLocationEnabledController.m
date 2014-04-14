//
//  GSDownloadLocationEnabledController.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 24/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSDownloadLocationEnabledController.h"

@implementation GSDownloadLocationEnabledController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(BOOL) downloadLocationEnabled {
    if ([[[GSSettings alloc] init]._autoDownloadWhenAdded isEqual:@(YES)] || [[[GSSettings alloc] init]._autoDownloadWhenUpdated isEqual:@(YES)]) {
        return YES;
    } else {
        return NO;
    }
}

- (IBAction)update:(id)sender {
    if ([[[GSSettings alloc] init]._autoDownloadWhenAdded isEqual:@(YES)] || [[[GSSettings alloc] init]._autoDownloadWhenUpdated isEqual:@(YES)]) {
        [_setDownloadFilename setEnabled:YES];
        [_setLocationButton setEnabled:YES];
    } else {
        [_setDownloadFilename setEnabled:NO];
        [_setLocationButton setEnabled:NO];
    }
    
}

@end
