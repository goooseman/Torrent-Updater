//
//  GSNumberTextFormatter.m
//  RuTracker Updater
//
//  Created by Alexander Gusev on 29.04.13.
//  Copyright (c) 2013 goooseman.ru. All rights reserved.
//  Taken from http://stackoverflow.com/questions/827014/how-to-limit-nstextfield-text-length-and-keep-it-always-upper-case
//

#import "GSNumberTextFormatter.h"





@implementation GSNumberTextFormatter

- (id)init {
    
    if(self = [super init]){
        
        maxLength = INT_MAX;
        
    }
    
    return self;
}

- (void)setMaximumLength:(int)len {
    maxLength = len;
}


- (int)maximumLength {
    return maxLength;
}


- (NSString *)stringForObjectValue:(id)object {
    return (NSString *)object;
}

- (BOOL)getObjectValue:(id *)object forString:(NSString *)string errorDescription:(NSString **)error {
    *object = string;
    return YES;
}

- (BOOL)isPartialStringValid:(NSString **)partialStringPtr
       proposedSelectedRange:(NSRangePointer)proposedSelRangePtr
              originalString:(NSString *)origString
       originalSelectedRange:(NSRange)origSelRange
            errorDescription:(NSString **)error {
    
    if ([*partialStringPtr length] > maxLength) {
        NSBeep();
        return NO;
    }
    
    NSScanner* scanner = [NSScanner scannerWithString:*partialStringPtr];
    
    if([*partialStringPtr length] == 0) {
        return YES;
    }
    if(!([scanner scanInt:0] && [scanner isAtEnd])) {
        NSBeep();
        return NO;
    }
    return YES;
}

- (NSAttributedString *)attributedStringForObjectValue:(id)anObject withDefaultAttributes:(NSDictionary *)attributes {
    return nil;
}

@end
