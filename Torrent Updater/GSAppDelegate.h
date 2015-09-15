//
//  GSAppDelegate.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 18/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <Sparkle/Sparkle.h>

#import "MASPreferencesWindowController.h"
#import "GSGeneralSettings.h"
#import "GSUpdateSettings.h"
#import "GSSettings.h"
#import "GSShowDockController.h"
#import "GSStatusItemController.h"
#import "GSTorrCheck.h"
#import "GSTorrAdd.h"
#import "GSNumberTextFormatter.h"
#import "GSTorrentsGetter.h"
#import "GSTorrUpdate.h"
#import "GSTimerController.h"
#import "GSAdditions.h"
#import "GSTorrDownload.h"
#import "GSAnalytics.h"
#import "GSHyperlinkTextField.h"

@interface GSAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate> {
    BOOL lastUpdatedIsVisible;
    NSInteger lastChangeCount;
	NSPasteboard *pasteboard;
    NSTimer *pasteboardTimer;
}

#pragma mark windowsProperties

@property (strong) NSWindowController *preferencesWindow;
@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSWindow *aboutWindow;
@property (unsafe_unretained) IBOutlet NSPanel *addTorrentPanel;
@property (weak) IBOutlet NSMenu *statusMenu;

#pragma mark addTorrentPanelProperties

@property (weak) IBOutlet NSProgressIndicator *ATPLoadingIndicator;
@property (weak) IBOutlet NSPopUpButton *ATPSelectTracker;
@property (weak) IBOutlet NSTextField *ATPLinkField;
@property (weak) IBOutlet NSTextField *ATPLinkFieldText;
@property (weak) IBOutlet NSTextField *ATPLoginRequired;
@property (weak) IBOutlet NSButton *ATPOpenInSafari;
@property (weak) IBOutlet NSButton *ATPAddButton;
@property (weak) IBOutlet NSButton *ATPTryOneMoreTime;
@property (weak) IBOutlet NSTextField *ATPNoInternetConnection;
@property (weak) IBOutlet NSButton *ATPNoInternetConnectionCheckOneMoreTime;


#pragma mark mainWindowProperties

@property (weak) IBOutlet NSTableView *torrentsTableView;
@property (weak) IBOutlet NSProgressIndicator *mainWindowLoadingIndicator;
@property (weak) IBOutlet NSTextField *loadingLabel;
@property (weak) IBOutlet NSTextField *lastUpdatedLabel;
@property (weak) IBOutlet NSButton *updateAllButton;

#pragma mark aboutWindowProperties

@property (weak) IBOutlet GSHyperlinkTextField *appLink;
@property (weak) IBOutlet GSHyperlinkTextField *contactAuthor;
@property (weak) IBOutlet GSHyperlinkTextField *olenyev;
@property (weak) IBOutlet GSHyperlinkTextField *aliyaSoap;

#pragma mark addTorrentPanelActions

- (IBAction)ATPOpenInSafariSel:(id)sender;
- (IBAction)ATPAddSel:(id)sender;
- (IBAction)ATPTrackerChooseSel:(id)sender;
- (IBAction)ATPOpenSel:(id)sender;
- (IBAction)ATPCloseSel:(id)sender;

#pragma mark mainWindowActions

- (IBAction)preferencesSel:(id)sender;
- (IBAction)updateAllSel:(id)sender;
- (void)tableClick:(id)object;


#pragma mark mainMenuActions

- (IBAction)openDestFolderSel:(id)sender;
- (IBAction)aboutSel:(id)sender;

#pragma mark statusMenuActions

- (IBAction)showAppSel:(id)sender;



#pragma mark torrentMenuActions

- (IBAction)openTorrInBrowser:(id)sender;
- (IBAction)removeTorr:(id)sender;
- (IBAction)updateSel:(id)sender;
- (IBAction)downloadSel:(id)sender;

#pragma mark functions

- (void)resizeWindow;
- (void)startLoadingIndicatorWithMessage:(NSString *)message;
- (void)stopLoadingIndicator;
- (void)stopLoadingIndicatorWithMessage:(NSString *)message;

@end
