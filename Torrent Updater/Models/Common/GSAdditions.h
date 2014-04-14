//
//  GSAdditions.h
//  Torrent Updater
//
//  Created by Alexander Gusev on 23/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface NSString (JRStringAdditions)

-(BOOL)containsString:(NSString *)string;
-(BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options;

@end

@interface NSString (GSStringAdditions)

-(NSString *)getSubstringBetween:(NSString *)first and:(NSString *)second;
-(NSString *)getSubstringUntil:(NSString *)separator;

@end

@interface NSProgressIndicator (GSAnimatedGitHubAppStyle)

-(void)setHiddenWithAnimationGitHubAppStyleAndStopSpinning;

@end

@interface NSView (GSAnimatedGitHubAppStyle)

-(void)setHiddenWithAnimationGitHubAppStyle;
-(void)setUnHiddenWithAnimationGitHubAppStyle;

@end

@interface NSAttributedString (Hyperlink)

+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;

@end



@interface GSAdditions : NSObject

@end
