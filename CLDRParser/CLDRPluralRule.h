//
//  CLDRPluralRule.h
//  CLDRParser
//
//  Created by Cory Kilger on 5/4/14.
//  Copyright (c) 2014 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLDRPluralOperands;

extern NSString * const CLDRPluralKeyZero;
extern NSString * const CLDRPluralKeyOne;
extern NSString * const CLDRPluralKeyTwo;
extern NSString * const CLDRPluralKeyFew;
extern NSString * const CLDRPluralKeyMany;
extern NSString * const CLDRPluralKeyOther;

@interface CLDRPluralRule : NSObject

@property (copy, readonly) NSString * language;

- (instancetype)initWithLocale:(NSLocale *)locale;
- (instancetype)initWithLanguageCode:(NSString *)language;

+ (NSArray *)supportedLanguageCodes;

- (NSString *)pluralKeyForInteger:(NSInteger)integer;
- (NSString *)pluralKeyForString:(NSString *)string;
- (NSString *)pluralKeyForString:(NSString *)string options:(NSDictionary *)options;
- (NSString *)pluralKeyForOperands:(CLDRPluralOperands *)operands;

@end
