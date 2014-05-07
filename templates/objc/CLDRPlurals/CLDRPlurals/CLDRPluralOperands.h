//
//  CLDRPluralOperands.h
//  CLDRParser
//
//  Created by Cory Kilger on 5/4/14.
//  Copyright (c) 2014 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CLDRPluralRuleOptionDecimalSeparator;

/**
 Represents a number as used by the plural rules. See specifications: http://unicode.org/reports/tr35/tr35-numbers.html#Language_Plural_Rules
 */
@interface CLDRPluralOperands : NSObject

@property (assign) double n;
@property (assign) unsigned long i;
@property (assign) unsigned long v;
@property (assign) unsigned long w;
@property (assign) unsigned long f;
@property (assign) unsigned long t;

- (instancetype)initWithCount:(NSInteger)count;
- (instancetype)initWithAmount:(float)amount;
- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string options:(NSDictionary *)options;

@end
