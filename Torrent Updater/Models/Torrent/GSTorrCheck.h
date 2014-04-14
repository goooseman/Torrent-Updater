//
//  GSTorrCheck.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 20/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSSettings.h"
#import "GSExtra.h"

@interface GSTorrCheck : NSObject

+(BOOL)loginCorrectAtTracker: (NSString *)tracker;

@end
