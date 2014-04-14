//
//  GSAnalytics.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 27/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSAnalytics.h"

@implementation GSAnalytics

+(void)sendPostWithMessage:(NSString *)message {
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://rutrackerupd.goooseman.ru/recievedata.php"]];
    [request setHTTPMethod:@"POST"];
    NSString *post = message;
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:request queue:[[GSExtra sharedInstance] sharedOperationQueue] completionHandler:nil];
    
}

+(void)onStartup {
    [self sendPostWithMessage: [NSString stringWithFormat:@"Event=Loaded&UDID=%@&OS=%@&Version=%@&TorrentsAddedNow=%ld", [self serialNumber], [self OSVersion], [self programVersion], [[GSTorrentsGetter getAllTorrents] count]]];
    
}


+(void)onShutdown {
    [self sendPostWithMessage:[NSString stringWithFormat:@"Event=ExitTimes&UDID=%@", [self serialNumber]]];
}

+(void)torrentHasBeenAdded {
    [self sendPostWithMessage:[NSString stringWithFormat:@"Event=AddTorrent&UDID=%@", [self serialNumber]]];
}

+(void)torrentHasBeenRemoved {
    [self sendPostWithMessage:[NSString stringWithFormat:@"Event=TorrentsDeleted&UDID=%@", [self serialNumber]]];
}

+(void)torrentHasBeenDownloaded {
    [self sendPostWithMessage:[NSString stringWithFormat:@"Event=TorrentsDownloaded&UDID=%@", [self serialNumber]]];
}

+(NSString *)serialNumber {
    io_service_t    platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault,
                                                                 
                                                                 IOServiceMatching("IOPlatformExpertDevice"));
    CFStringRef serialNumberAsCFString = NULL;
    
    if (platformExpert) {
        serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert,
                                                                 CFSTR(kIOPlatformSerialNumberKey),
                                                                 kCFAllocatorDefault, 0);
        IOObjectRelease(platformExpert);
    }
    
    NSString *serialNumberAsNSString = nil;
    if (serialNumberAsCFString) {
        serialNumberAsNSString = [NSString stringWithString:(__bridge NSString *)serialNumberAsCFString];
        CFRelease(serialNumberAsCFString);
    }
    
    return serialNumberAsNSString;
}

+(NSString *)OSVersion {
    return [[NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"] objectForKey:@"ProductVersion"];
}

+ (NSString *)programVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}
@end
