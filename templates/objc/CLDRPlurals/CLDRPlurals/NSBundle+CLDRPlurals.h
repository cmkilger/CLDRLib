//
//  NSBundle+CLDRPlurals.h
//  CLDRParser
//
//  Created by Cory Kilger on 5/5/14.
//  Copyright (c) 2014 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CLDRPluralLocalizedStringWithCount(key, count, comment) [[NSBundle mainBundle] pluralLocalizedStringForKey:key count:count value:value table:tableName]
#define CLDRPluralLocalizedStringWithAmount(key, amount, comment) [[NSBundle mainBundle] pluralLocalizedStringForKey:key amount:amount value:value table:tableName]
#define CLDRPluralLocalizedString(key, plural, comment) [[NSBundle mainBundle] pluralLocalizedStringForKey:key pluralValue:plural options:nil value:value table:tableName]

@interface NSBundle (CLDRPlurals)

- (NSString *)pluralLocalizedStringForKey:(NSString *)key count:(NSInteger)count value:(NSString *)value table:(NSString *)tableName;
- (NSString *)pluralLocalizedStringForKey:(NSString *)key amount:(float)amount value:(NSString *)value table:(NSString *)tableName;
- (NSString *)pluralLocalizedStringForKey:(NSString *)key pluralValue:(NSString *)plural options:(NSDictionary *)options value:(NSString *)value table:(NSString *)tableName;

@end
