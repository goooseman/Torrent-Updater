//
//  GSAdditions.m
//  Torrent Updater
//
//  Created by Alexander Gusev on 23/03/14.
//  Copyright (c) 2014 Alexander Gusev. All rights reserved.
//

#import "GSAdditions.h"

@implementation NSString (JRStringAdditions)

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

@end

@implementation NSString (GSStringAdditions)

-(NSString *)getSubstringBetween:(NSString *)first and:(NSString *)second {
    NSRange startRange = [self rangeOfString:first];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;
        NSRange endRange = [self rangeOfString:second options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [self substringWithRange:targetRange];
        }
    }
    return nil;
}

-(NSString *)getSubstringUntil:(NSString *)separator {
    if ([self rangeOfString:separator].location != NSNotFound)
        return [self substringToIndex:[self rangeOfString:separator].location];
    else
        return self;
}

@end

@implementation NSProgressIndicator (GSAnimatedGitHubAppStyle)

-(void)setHiddenWithAnimationGitHubAppStyleAndStopSpinning {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setDuration: 0.5];
        [context setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
        NSRect textFieldRect = [self frame];
        textFieldRect.origin.y = -19;
        [self.animator setFrame:textFieldRect];
    }
                        completionHandler:^{
                            [self setHidden:YES];
                            [self stopAnimation:nil];
                            
                        }];
}

@end

@implementation NSView (GSAnimatedGitHubAppStyle)

-(void)setHiddenWithAnimationGitHubAppStyle {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setDuration: 0.5];
        [context setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
        NSRect textFieldRect = [self frame];
        textFieldRect.origin.y = -19;
        [self.animator setFrame:textFieldRect];
    }
                        completionHandler:^{
                            [self setHidden:YES];
                            
                        }];
}

-(void)setUnHiddenWithAnimationGitHubAppStyle {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setDuration: 0.0];
        [context setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]];
        NSRect textFieldRect = [self frame];
        textFieldRect.origin.y = -19;
        [self.animator setFrame:textFieldRect];
    }
                        completionHandler:^{
                            [self setHidden:NO];
                            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                                [context setDuration: 0.5];
                                [context setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]];
                                NSRect textFieldRect = [self frame];
                                textFieldRect.origin.y = 8;
                                [self.animator setFrame:textFieldRect];
                            } completionHandler: ^{}];
                        }];

}

@end

@implementation NSAttributedString (Hyperlink)

+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL {
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
    NSRange range = NSMakeRange(0, [attrString length]);
    
    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
    [attrString setAlignment:NSCenterTextAlignment range:range];
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
    [attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    
    [attrString addAttribute:NSAlignmentBinding value:[NSNumber numberWithInt:NSCenterTextAlignment] range:range];
    [attrString addAttribute:@"NSFont" value:[NSFont systemFontOfSize:13.0] range:range];
    [attrString endEditing];
    
    return attrString;
}
@end


@implementation GSAdditions

@end
