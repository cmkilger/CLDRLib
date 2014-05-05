//
//  CLDRPluralOperands.m
//  CLDRParser
//
//  Created by Cory Kilger on 5/4/14.
//  Copyright (c) 2014 Cory Kilger. All rights reserved.
//

#import "CLDRPluralOperands.h"

NSString * const CLDRPluralRuleOptionDecimalSeparator = @"RuleOptionDecimalSeparator";

static inline NSString * trimTrailingZeros(NSString * number) {
    char buffer[64];
    [number getCString:buffer maxLength:63 encoding:NSASCIIStringEncoding];
    int length = (int)strlen(buffer);
    for (int i = length-1; i >= 0 && buffer[i] == '0'; i--) {
        buffer[i] = 0;
    }
    return [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
}

#define StripNonDigits(x) [x stringByReplacingOccurrencesOfString:@"[^\\d]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [x length])]

@implementation CLDRPluralOperands

- (instancetype)initWithCount:(NSInteger)count {
    self = [super init];
    if (self) {
        _n = count;
        _i = count;
    }
    return self;
}

- (instancetype)initWithAmount:(float)amount {
    return [self initWithString:[@(amount) stringValue]];
}

- (instancetype)initWithString:(NSString *)string {
    return [self initWithString:string options:nil];
}

- (instancetype)initWithString:(NSString *)string options:(NSDictionary *)options {
    NSString * decimalSeparator = @".";
    if (options[CLDRPluralRuleOptionDecimalSeparator]) {
        decimalSeparator = options[CLDRPluralRuleOptionDecimalSeparator];
    }
    
    NSArray * components = [string componentsSeparatedByString:decimalSeparator];
    if ([components count] < 1 || [components count] > 2) return nil;
    
    NSString * integer = StripNonDigits(components[0]);
    if ([integer length] == 0) return nil;
    
    NSString * fraction = ([components count] == 2) ? StripNonDigits(components[1]) : nil;
    NSString * normalized = ([fraction length] > 0) ? [integer stringByAppendingFormat:@".%@", fraction] : integer;
    NSString * trimmed = ([fraction length] > 0) ? trimTrailingZeros(fraction) : nil;
    
    self = [super init];
    if (self) {
        self.n = [normalized doubleValue];
        self.i = [integer integerValue];
        self.v = [fraction length];
        self.w = [trimmed length];
        self.f = [fraction integerValue];
        self.t = [trimmed integerValue];
    }
    return self;
}

- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"<%@: 0x%lx; n:%@; i:%lu; v:%lu; w:%lu; f:%lu; t:%lu>", [self class], (unsigned long)self, @(_n), _i, _v, _w, _f, _t];
}

@end
