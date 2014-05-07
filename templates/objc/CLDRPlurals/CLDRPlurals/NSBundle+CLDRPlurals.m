//
//  NSBundle+CLDRPlurals.m
//  CLDRParser
//
//  Created by Cory Kilger on 5/5/14.
//  Copyright (c) 2014 Cory Kilger. All rights reserved.
//

#import "NSBundle+CLDRPlurals.h"
#import "CLDRPluralOperands.h"
#import "CLDRPluralRule.h"

@implementation NSBundle (CLDRPlurals)

static inline CLDRPluralRule * CurrentRule() {
    static CLDRPluralRule * rule = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rule = [[CLDRPluralRule alloc] initWithLocale:[NSLocale currentLocale]];
    });
    return rule;
}

- (NSString *)pluralLocalizedStringForKey:(NSString *)key count:(NSInteger)count value:(NSString *)value table:(NSString *)tableName {
    NSString * pluralKey = [CurrentRule() pluralKeyForInteger:count];
    return [self localizedStringForKey:[key stringByAppendingFormat:@".%@", pluralKey] value:value table:tableName];
}

- (NSString *)pluralLocalizedStringForKey:(NSString *)key amount:(float)amount value:(NSString *)value table:(NSString *)tableName {
    NSString * pluralKey = [CurrentRule() pluralKeyForString:[@(amount) stringValue]];
    return [self localizedStringForKey:[key stringByAppendingFormat:@".%@", pluralKey] value:value table:tableName];
}

- (NSString *)pluralLocalizedStringForKey:(NSString *)key pluralValue:(NSString *)plural options:(NSDictionary *)options value:(NSString *)value table:(NSString *)tableName {
    NSString * pluralKey = [CurrentRule() pluralKeyForString:plural options:options];
    return [self localizedStringForKey:[key stringByAppendingFormat:@".%@", pluralKey] value:value table:tableName];
}

@end
