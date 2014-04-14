//
//  GSNumberTextFormatter.h
//  RuTracker Updater
//
//  Created by Alexander Gusev on 29.04.13.
//  Copyright (c) 2013 goooseman.ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSNumberTextFormatter : NSFormatter {
    int maxLength;
   
}
- (void)setMaximumLength:(int)len;
- (int)maximumLength;


@end
