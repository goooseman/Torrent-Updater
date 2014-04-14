//
//  GSUpdateSettings.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 27/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSUpdateSettings.h"

@interface GSUpdateSettings ()

@end

@implementation GSUpdateSettings

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(NSString *)identifier{
    return NSLocalizedString(@"Auto Update", "Auto Update");
}

-(NSImage *)toolbarItemImage{
    return [NSImage imageNamed:@"software_update"];
}

-(NSString *)toolbarItemLabel{
    return NSLocalizedString(@"Auto Update", "Auto Update");
}

@end
