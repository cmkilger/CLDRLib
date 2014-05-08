//
//  CLDRPluralRule.m
//  CLDRParser
//
//  Created by Cory Kilger on 5/4/14.
//  Copyright (c) 2014 Cory Kilger. All rights reserved.
//

#import "CLDRPluralRule.h"
#import "CLDRPluralOperands.h"

NSString * const CLDRPluralKeyZero  = @"zero";
NSString * const CLDRPluralKeyOne   = @"one";
NSString * const CLDRPluralKeyTwo   = @"two";
NSString * const CLDRPluralKeyFew   = @"few";
NSString * const CLDRPluralKeyMany  = @"many";
NSString * const CLDRPluralKeyOther = @"other";

typedef NSString *(^CLDRPluralRuleBlock)(CLDRPluralOperands * o);

NSDictionary * CLDRPluralRules() {
    static NSDictionary * rules = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
<#rules#>    });
    return rules;
}

CLDRPluralRuleBlock CLDRPluralRuleForLanguage(NSString * language) {
    return CLDRPluralRules()[language];
}

@interface CLDRPluralRule ()

@property (copy, readwrite) NSString * language;
@property (copy) CLDRPluralRuleBlock rule;

@end

@implementation CLDRPluralRule

- (instancetype)initWithLocale:(NSLocale *)locale {
    NSMutableArray * possibilities = [[NSMutableArray alloc] init];
    NSString * languageCode = [locale objectForKey:NSLocaleLanguageCode];
    NSString * countryCode = [locale objectForKey:NSLocaleCountryCode];
    [possibilities addObject:languageCode];
    [possibilities addObject:[languageCode stringByAppendingFormat:@"-%@", countryCode]];
    
    NSDictionary * rules = CLDRPluralRules();
    for (NSString * possibility in possibilities) {
        if (rules[possibility]) {
            return [self initWithLanguageCode:possibility];
        }
    }
    
    return nil;
}

- (instancetype)initWithLanguageCode:(NSString *)language {
    CLDRPluralRuleBlock rule = CLDRPluralRuleForLanguage(language);
    if (!rule) return nil;
    
    self = [super init];
    if (self) {
        _rule = [rule copy];
        _language = language;
    }
    return self;
}

+ (NSArray *)supportedLanguageCodes {
    return [CLDRPluralRules() allKeys];
}

- (NSString *)pluralKeyForInteger:(NSInteger)integer {
    CLDRPluralOperands * o = [[CLDRPluralOperands alloc] init];
    o.n = integer;
    o.i = integer;
    return [self pluralKeyForOperands:o];
}

- (NSString *)pluralKeyForString:(NSString *)string {
    return [self pluralKeyForString:string options:nil];
}

- (NSString *)pluralKeyForString:(NSString *)string options:(NSDictionary *)options {
    return [self pluralKeyForOperands:[[CLDRPluralOperands alloc] initWithString:string options:options]];
}

- (NSString *)pluralKeyForOperands:(CLDRPluralOperands *)operands {
    return _rule(operands);
}

- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"<%@: 0x%lx; language:%@>", [self class], (unsigned long)self, _language];
}

@end
