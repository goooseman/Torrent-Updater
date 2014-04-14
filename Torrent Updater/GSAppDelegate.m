//
//  GSAppDelegate.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 18/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSAppDelegate.h"


@implementation GSAppDelegate

#pragma mark -
#pragma mark appDelegate

-(id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [GSSettings setDefaults];
    [[[GSShowDockController alloc] init] setShowDock:[[[GSSettings alloc] init]._showDock boolValue]];
    [[GSStatusItemController sharedInstance] setMenuItem:[[[GSSettings alloc] init]._menuItem boolValue] withMenu:_statusMenu];
    
    [self resizeWindow];
    [_torrentsTableView setTarget:self];
    [_torrentsTableView setAction:@selector(tableClick:)];
    [[GSTimerController sharedInstance] startAutoUpdateTimer];
    [self updateAllSel:nil];
    [GSAnalytics onStartup];
    
    
    [_appLink setHyperlinkTextFieldWithText:@"http://torrent-updater.goooseman.ru" andLink:@"http://torrent-updater.goooseman.ru"];
    [_contactAuthor setHyperlinkTextFieldWithText:NSLocalizedString(@"Contact Author", nil) andLink:@"mailto:rutrackerupd@goooseman.ru"];
    [_olenyev setHyperlinkTextFieldWithText:@"olenyev" andLink:@"https://twitter.com/olenyevtweet"];
    if (_aliyaSoap)
        [_aliyaSoap setHyperlinkTextFieldWithText:@"Онлайн бутик домашнего мыла Aliya" andLink:@"http://aliya-soap.ru"];
    
}

-(void)applicationShouldTerminateAfterLastWindowClosed {
    [GSAnalytics onShutdown];
}

-(void)menuWillOpen:(NSMenu *)menu{
    
    if([[menu title] isEqualToString:@"torrentMenu"]){
        NSInteger row = [_torrentsTableView clickedRow];
        if (row != -1 && ![_torrentsTableView isRowSelected:row]) {
            NSInteger theClickedRow = [_torrentsTableView clickedRow];
            NSIndexSet *thisIndexSet = [NSIndexSet indexSetWithIndex:theClickedRow];
            [_torrentsTableView selectRowIndexes:thisIndexSet byExtendingSelection:NO];
        }
    }
}

-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if (!flag) {
        [[self window] makeKeyAndOrderFront:nil];
    }
    return YES;
}


#pragma mark -
#pragma mark tableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSArray *torArray = [GSTorrentsGetter getAllTorrents];
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if( [tableColumn.identifier isEqualToString:@"MainColumn"] )
    {
        NSDictionary *thisTorrDict = [torArray objectAtIndex:row];
        cellView.textField.stringValue = [thisTorrDict objectForKey:@"title"];
        cellView.identifier = [thisTorrDict objectForKey:@"ID"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:NSLocalizedString(@"Last Updated", nil)];
        
        NSArray *subviews = cellView.subviews;
        NSTextField *trackerLabel = [subviews objectAtIndex:1];
        NSTextField *lastModifiedLabel = [subviews objectAtIndex:2];
        NSTextField *lastUpdatedLabel = [subviews objectAtIndex:3];
        trackerLabel.stringValue = [NSString stringWithFormat:@"%@", [thisTorrDict objectForKey:@"tracker"]];
        lastUpdatedLabel.stringValue = [NSString stringWithFormat:@"%@", [df stringFromDate: [thisTorrDict objectForKey:@"updated"]]];
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [df setDateFormat:NSLocalizedString(@"Last Modified", nil)];
        lastModifiedLabel.stringValue = [NSString stringWithFormat:@"%@", [df stringFromDate: [thisTorrDict objectForKey:@"modified"]]];
        NSColor *colorOld = [NSColor headerColor];
        NSColor *colorNew = [NSColor colorWithCalibratedRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        if ([[thisTorrDict objectForKey:@"new"] isEqualTo:@(YES)]) {
            [lastUpdatedLabel setTextColor:colorNew];
            [lastModifiedLabel setTextColor:colorNew];
        } else {
            [lastUpdatedLabel setTextColor:colorOld];
            [lastModifiedLabel setTextColor:colorOld];
        }
        return cellView;
    }
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[GSTorrentsGetter getAllTorrents] count];
}

#pragma mark -
#pragma mark addTorrentPanelActions


- (IBAction)ATPAddSel:(id)sender {
    [self ATPCloseSel:(id)sender];
    [self startLoadingIndicatorWithMessage:NSLocalizedString(@"Adding Torrent", nil)];
    NSBlockOperation* myOp = [NSBlockOperation blockOperationWithBlock:^{
        [GSTorrAdd addTorrWithNumber:[NSNumber numberWithInteger: [_ATPLinkField integerValue]] atTracker:[_ATPSelectTracker titleOfSelectedItem]];
    }];
    [myOp setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_torrentsTableView reloadData];
            [self resizeWindow];
            [self stopLoadingIndicator];
        });

    }];
    [[[GSExtra sharedInstance] sharedOperationQueue] addOperation:myOp];
}



- (IBAction)ATPTrackerChooseSel:(id)sender {
    if (![GSExtra checkInternet]) {
        [_ATPNoInternetConnection setHidden:NO];
        [_ATPNoInternetConnectionCheckOneMoreTime setHidden:NO];
        [_ATPLoginRequired setHidden:YES];
        [_ATPOpenInSafari setHidden:YES];
        [_ATPTryOneMoreTime setHidden:YES];
        [_ATPLinkFieldText setHidden:YES];
        [_ATPLinkField setHidden:YES];
        [_ATPAddButton setEnabled:NO];
        return;
    }
    [_ATPLoadingIndicator startAnimation:(id)sender];
    [_ATPAddButton setEnabled:NO];
    [_ATPLinkField setEnabled:NO];
    __block BOOL loginOK;
    NSBlockOperation* myOp = [NSBlockOperation blockOperationWithBlock:^{
        loginOK = [GSTorrCheck loginCorrectAtTracker:[_ATPSelectTracker titleOfSelectedItem]];
    }];
    [myOp setCompletionBlock:^{
        [_ATPLoadingIndicator stopAnimation:(id)sender];
        if (loginOK) {
            [_ATPLinkField setEnabled:YES];
            [_ATPAddButton setEnabled:YES];
            [_ATPLoginRequired setHidden:YES];
            [_ATPOpenInSafari setHidden:YES];
            [_ATPTryOneMoreTime setHidden:YES];
            [_ATPLinkFieldText setHidden:NO];
            [_ATPLinkField setHidden:NO];
            [_ATPNoInternetConnection setHidden:YES];
            [_ATPNoInternetConnectionCheckOneMoreTime setHidden:YES];
        } else {
            [_ATPLoginRequired setHidden:NO];
            [_ATPOpenInSafari setHidden:NO];
            [_ATPTryOneMoreTime setHidden:NO];
            [_ATPLinkFieldText setHidden:YES];
            [_ATPLinkField setHidden:YES];
            [_ATPNoInternetConnection setHidden:YES];
            [_ATPNoInternetConnectionCheckOneMoreTime setHidden:YES];
        }
    }];
    [[[GSExtra sharedInstance] sharedOperationQueue] addOperation:myOp];
    

}

- (IBAction)ATPOpenInSafariSel:(id)sender {
    [GSExtra openInSafari:[[GSSettings getSettingsForTracker:[_ATPSelectTracker titleOfSelectedItem]] objectForKey:@"loginCheckURL"]];
}
- (IBAction)ATPOpenSel:(id)sender {
    [NSApp beginSheet:_addTorrentPanel modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
    [_ATPSelectTracker addItemsWithTitles:[GSSettings getTrackersList]];
    [self ATPTrackerChooseSel:(id)sender];
    
    GSNumberTextFormatter *format = [[GSNumberTextFormatter alloc] init];
    [format setMaximumLength:7];
    [[_ATPLinkField cell] setFormatter:format];
    
}
- (IBAction)ATPCloseSel:(id)sender {
    [_addTorrentPanel orderOut:nil];
    [NSApp endSheet:_addTorrentPanel];
}

#pragma mark -
#pragma mark mainWindowActions

- (IBAction)preferencesSel:(id)sender {
    if(_preferencesWindow == nil){
        NSViewController *generalViewController = [[GSGeneralSettings alloc] initWithNibName:@"GSGeneralSettings" bundle:[NSBundle mainBundle]];
        NSViewController *updateViewController = [[GSUpdateSettings alloc] initWithNibName:@"GSUpdateSettings" bundle:[NSBundle mainBundle]];
        NSArray *views = [NSArray arrayWithObjects:generalViewController, updateViewController, nil];
        NSString *title = NSLocalizedString(@"Preferences", nil);
        _preferencesWindow = [[MASPreferencesWindowController alloc] initWithViewControllers:views title:title];
    }
    NSApplication *myApp = [NSApplication sharedApplication];
    [myApp activateIgnoringOtherApps:YES];
    [self.preferencesWindow showWindow:self];
}

- (IBAction)updateAllSel:(id)sender {
    
    [self startLoadingIndicatorWithMessage:NSLocalizedString(@"Updating All Torrents", nil)];

    
    NSBlockOperation* myOp = [NSBlockOperation blockOperationWithBlock:^{
        [GSTorrUpdate updateAllTorrents];
    }];
    [myOp setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_torrentsTableView reloadData];
            [[GSStatusItemController sharedInstance] changeIcon];
            [[[GSShowDockController alloc] init] changeBadge];
            [self stopLoadingIndicator];
        });

    }];
    [[[GSExtra sharedInstance] sharedOperationQueue] addOperation:myOp];
}



-(void)tableClick:(id)object {
    
    // Left click makes item not new, if it is new //
    NSInteger rowNumber = [_torrentsTableView clickedRow];
    if (rowNumber == -1)
        return;
    NSTableCellView *thisCell = [_torrentsTableView viewAtColumn:0 row:rowNumber makeIfNecessary:YES];
    NSNumber *torrID = [NSNumber numberWithInteger:[thisCell.identifier integerValue]];
    NSTextField *thisCellTrackerField = [thisCell.subviews objectAtIndex:1];
    NSString *tracker = thisCellTrackerField.stringValue;
    NSNumber *new = [[GSTorrentsGetter getDictForTorID:torrID atTracker:tracker] objectForKey:@"new"];
    if ([new isEqual:@(YES)]) {
        [GSTorrentsSetter writeValue:@(NO) at:@"new" forTorID:torrID atTracker:tracker];
        [_torrentsTableView reloadData];
        [[GSStatusItemController sharedInstance] changeIcon];
        [[[GSShowDockController alloc] init] changeBadge];
    }
    
}

#pragma mark -
#pragma mark mainMenuActions

- (IBAction)openDestFolderSel:(id)sender {
    NSURL *folderURL = [NSURL fileURLWithPath:[[[GSSettings alloc] init]._fileLocation stringByExpandingTildeInPath]];
    [[NSWorkspace sharedWorkspace] openURL:folderURL];
}

- (IBAction)aboutSel:(id)sender {
    NSApplication *myApp = [NSApplication sharedApplication];
    [myApp activateIgnoringOtherApps:YES];
    [_aboutWindow makeKeyAndOrderFront:self];
}

#pragma mark -
#pragma mark statusMenuActions

- (IBAction)showAppSel:(id)sender {
    NSApplication *myApp = [NSApplication sharedApplication];
    [myApp activateIgnoringOtherApps:YES];
    [self.window orderFrontRegardless];
}

#pragma mark -
#pragma mark torrentMenuActions

- (IBAction)openTorrInBrowser:(id)sender {
    NSIndexSet *selectedRows = [_torrentsTableView selectedRowIndexes];
    [selectedRows enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSTableCellView *thisCell = [_torrentsTableView viewAtColumn:0 row:idx makeIfNecessary:YES];
        NSNumber *torrID = [NSNumber numberWithInteger:[thisCell.identifier integerValue]];
        NSTextField *thisCellTrackerField = [thisCell.subviews objectAtIndex:1];
        NSString *tracker = thisCellTrackerField.stringValue;
        NSString *trackerTorrURL = [[GSSettings getSettingsForTracker:tracker] objectForKey:@"torrentUrl"];
        [GSExtra openInDefaultBrowser:[NSString stringWithFormat:@"%@%@", trackerTorrURL,torrID]];
    }];
}

- (IBAction)removeTorr:(id)sender {
    NSIndexSet *selectedRows = [_torrentsTableView selectedRowIndexes];
    [selectedRows enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSTableCellView *thisCell = [_torrentsTableView viewAtColumn:0 row:idx makeIfNecessary:YES];
        NSNumber *torrID = [NSNumber numberWithInteger:[thisCell.identifier integerValue]];
        NSTextField *thisCellTrackerField = [thisCell.subviews objectAtIndex:1];
        NSString *tracker = thisCellTrackerField.stringValue;
        [GSTorrentsSetter removeTorrentID:torrID atTracker:tracker];
        [_torrentsTableView reloadData];
        [self resizeWindow];
        
    }];
}

- (IBAction)updateSel:(id)sender {
    
    NSIndexSet *selectedRows = [_torrentsTableView selectedRowIndexes];
    [selectedRows enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [self startLoadingIndicatorWithMessage:NSLocalizedString(@"Updating", nil)];
        NSTableCellView *thisCell = [_torrentsTableView viewAtColumn:0 row:idx makeIfNecessary:YES];
        NSNumber *torrID = [NSNumber numberWithInteger:[thisCell.identifier integerValue]];
        NSTextField *thisCellTrackerField = [thisCell.subviews objectAtIndex:1];
        NSString *tracker = thisCellTrackerField.stringValue;
        NSBlockOperation* myOp = [NSBlockOperation blockOperationWithBlock:^{
            [GSTorrUpdate updateTorrWithNumber:torrID atTracker:tracker];
        }];
        [myOp setCompletionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_torrentsTableView reloadData];
                [[GSStatusItemController sharedInstance] changeIcon];
                [[[GSShowDockController alloc] init] changeBadge];
                [self stopLoadingIndicator];
            });

        }];
        [[[GSExtra sharedInstance] sharedOperationQueue] addOperation:myOp];
    }];
}

- (IBAction)downloadSel:(id)sender {
    NSIndexSet *selectedRows = [_torrentsTableView selectedRowIndexes];
    [selectedRows enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSTableCellView *thisCell = [_torrentsTableView viewAtColumn:0 row:idx makeIfNecessary:YES];
        NSNumber *torrID = [NSNumber numberWithInteger:[thisCell.identifier integerValue]];
        NSTextField *thisCellTrackerField = [thisCell.subviews objectAtIndex:1];
        NSString *tracker = thisCellTrackerField.stringValue;
        NSBlockOperation* myOp = [NSBlockOperation blockOperationWithBlock:^{
            [[[GSTorrDownload alloc] init] downloadTorrWithNumber:torrID atTracker:tracker];
        }];
        [[[GSExtra sharedInstance] sharedOperationQueue] addOperation:myOp];
    }];
}


#pragma mark -
#pragma mark functions

-(void)resizeWindow {
    NSRect windowFrame = [_window frame];
    windowFrame.size.height = [_torrentsTableView numberOfRows] * 50 + 21 + 32;
    [self.window  setFrame:windowFrame display:YES animate:YES];
}

-(void)startLoadingIndicatorWithMessage:(NSString *)message {
    lastUpdatedIsVisible = NO;
    [_mainWindowLoadingIndicator startAnimation:nil];
    [_mainWindowLoadingIndicator setUnHiddenWithAnimationGitHubAppStyle];
    [GSSettings setactionsAreEnabled:@(NO)];
    [_loadingLabel setStringValue:message];
    [_loadingLabel setUnHiddenWithAnimationGitHubAppStyle];
    [_lastUpdatedLabel setHiddenWithAnimationGitHubAppStyle];
}

-(void)stopLoadingIndicator {
    if (lastUpdatedIsVisible == YES) {
        [GSSettings setactionsAreEnabled:@(YES)];
        return;
    }
    lastUpdatedIsVisible = YES;
    [_mainWindowLoadingIndicator setHiddenWithAnimationGitHubAppStyleAndStopSpinning];
    [GSSettings setactionsAreEnabled:@(YES)];
    [_loadingLabel setHiddenWithAnimationGitHubAppStyle];
    [_lastUpdatedLabel setUnHiddenWithAnimationGitHubAppStyle];
    if ([[GSSettings alloc] init]._lastUpdated) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:NSLocalizedString(@"Last Updated", nil)];
        [_lastUpdatedLabel setStringValue:[df stringFromDate:[[GSSettings alloc] init]._lastUpdated]];
    } else {
        [_lastUpdatedLabel setStringValue:NSLocalizedString(@"Never Updated", nil)];
    }
    
}

-(void)stopLoadingIndicatorWithMessage:(NSString *)message {
    lastUpdatedIsVisible = YES;
    [GSSettings setactionsAreEnabled:@(YES)];
    [_mainWindowLoadingIndicator setHiddenWithAnimationGitHubAppStyleAndStopSpinning];
    [_loadingLabel setHiddenWithAnimationGitHubAppStyle];
    [_lastUpdatedLabel setUnHiddenWithAnimationGitHubAppStyle];
    [_lastUpdatedLabel setStringValue:message];
}


@end
