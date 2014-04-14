//
//  GSGeneralSettings.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 18/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSGeneralSettings.h"

@interface GSGeneralSettings ()

@end

@implementation GSGeneralSettings

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib {
    
    
    
}

-(NSString *)identifier{
    return NSLocalizedString(@"General", "General");
}

-(NSImage *)toolbarItemImage{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

-(NSString *)toolbarItemLabel{
    return NSLocalizedString(@"General", "General");
}


#pragma mark -
#pragma mark selectors

- (IBAction)autoRefreshSel:(id)sender {
    [[GSTimerController sharedInstance] startAutoUpdateTimer];
}

-(IBAction)menuBarItemSel:(id)sender {
    NSButton *menuBarItem = sender;
    [[GSStatusItemController sharedInstance] setMenuItem:[menuBarItem state] withMenu:nil];
}


-(IBAction)selectFolderSel:(id)sender {
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseDirectories:YES];
    
    if ( [openDlg runModal] == NSOKButton )
    {
        [GSSettings setFileLocation: [[[[openDlg URLs] objectAtIndex:0] path] stringByAbbreviatingWithTildeInPath]];
        
    }
}








@end
