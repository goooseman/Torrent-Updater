//
//  GSExtra.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 21/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSAdditions.h"
#import "GSTorrCheck.h"
#import "GSAppDelegate.h"

@interface GSExtra : NSObject {
    NSOperationQueue *operationQueue;
    BOOL loginFailedErrorHasBeenAlerted;
    BOOL noInternetConnectionErrorHasBeenAlerted;
}

+(GSExtra *) sharedInstance;

-(NSOperationQueue *)sharedOperationQueue;
+(void)showError:(NSString *)errorMessage;
+(void)showError:(NSString *)errorMessage withInformativeMessage:(NSString *)informativeMessage;
+(void)openInSafari:(NSString *)link;
+(void)openInDefaultBrowser:(NSString *)link;
+(BOOL)checkInternet;
-(BOOL)checkInternetAndShowError;
-(BOOL)checkLoginAndShowErrorForTracker:(NSString *)tracker;

@end
