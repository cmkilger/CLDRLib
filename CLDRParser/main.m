//
//  main.m
//  CLDRParser
//
//  Created by Cory Kilger on 5/2/14.
//  Copyright (c) 2014 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const CLDRPluralRuleOptionDecimalSeparator = @"RuleOptionDecimalSeparator";

static NSString * const CLDRPluralZero  = @"zero";
static NSString * const CLDRPluralOne   = @"one";
static NSString * const CLDRPluralTwo   = @"two";
static NSString * const CLDRPluralFew   = @"few";
static NSString * const CLDRPluralMany  = @"many";
static NSString * const CLDRPluralOther = @"other";

#define StripNonDigits(x) [x stringByReplacingOccurrencesOfString:@"[^\\d]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [x length])]

NSString * trimTrailingZeros(NSString * number) {
    char buffer[64];
    [number getCString:buffer maxLength:63 encoding:NSASCIIStringEncoding];
    int length = (int)strlen(buffer);
    for (int i = length-1; i >= 0 && buffer[i] == '0'; i--) {
        buffer[i] = 0;
    }
    return [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
}

typedef struct {
    double n;
    unsigned long i;
    unsigned long v;
    unsigned long w;
    unsigned long f;
    unsigned long t;
} CLDRPluralOperands;

#define CLDRPluralOperandsNotFound __CLDRPluralOperandsNotFound()
static inline CLDRPluralOperands __CLDRPluralOperandsNotFound() {
    CLDRPluralOperands op = {0, 0, 0, 0, 0, 0};
    return op;
}

CLDRPluralOperands OperandsFromString(NSString * number, NSDictionary * options) {
    NSString * decimalSeparator = @".";
    if (options[CLDRPluralRuleOptionDecimalSeparator]) {
        decimalSeparator = options[CLDRPluralRuleOptionDecimalSeparator];
    }
    
    NSArray * components = [number componentsSeparatedByString:decimalSeparator];
    
    if ([components count] < 1 || [components count] > 2) {
        return CLDRPluralOperandsNotFound;
    }
    
    NSString * integer = StripNonDigits(components[0]);
    NSString * fraction = ([components count] == 2) ? StripNonDigits(components[1]) : nil;
    NSString * normalized = ([fraction length] > 0) ? [integer stringByAppendingFormat:@".%@", fraction] : integer;
    NSString * trimmed = ([fraction length] > 0) ? trimTrailingZeros(fraction) : nil;
    
    CLDRPluralOperands operands;
    operands.n = [normalized doubleValue];
    operands.i = [integer integerValue];
    operands.v = [fraction length];
    operands.w = [trimmed length];
    operands.f = [fraction integerValue];
    operands.t = [trimmed integerValue];
    
    //    NSLog(@"%@ %d %d %d %d %d", normalized, operands.i, operands.v, operands.w, operands.f, operands.t);
    
    return operands;
}

typedef NSString *(^CLDRPluralRuleBlock)(CLDRPluralOperands o);

NSDictionary * CLDRPluralRules() {
    static NSDictionary * rules = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rules = @{
          @"fa": ^(CLDRPluralOperands o){
              if (((o.i == 0)) || ((o.n == 1))) return @"one";
              return @"other";
          },
          @"brx": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"ks": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"nn": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"hy": ^(CLDRPluralOperands o){
              if ((((0 <= o.i && o.i <= 1)))) return @"one";
              return @"other";
          },
          @"no": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"te": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"ku": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"wa": ^(CLDRPluralOperands o){
              if ((((0 <= o.n && o.n <= 1)))) return @"one";
              return @"other";
          },
          @"kw": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              if (((o.n == 2))) return @"two";
              return @"other";
          },
          @"ff": ^(CLDRPluralOperands o){
              if ((((0 <= o.i && o.i <= 1)))) return @"one";
              return @"other";
          },
          @"nr": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"pap": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"sah": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"th": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"ti": ^(CLDRPluralOperands o){
              if ((((0 <= o.n && o.n <= 1)))) return @"one";
              return @"other";
          },
          @"mgo": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"ky": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"tk": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"fi": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"id": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"ksb": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"tl": ^(CLDRPluralOperands o){
              if (((o.v == 0) && ((1 <= o.i && o.i <= 3))) || ((o.v == 0) && (!(fmod(o.i, 10) == 4 || fmod(o.i, 10) == 6 || fmod(o.i, 10) == 9))) || ((!(o.v == 0)) && (!(fmod(o.f, 10) == 4 || fmod(o.f, 10) == 6 || fmod(o.f, 10) == 9)))) return @"one";
              return @"other";
          },
          @"tn": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"ig": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"lb": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"ny": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"to": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"cs": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              if ((((2 <= o.i && o.i <= 4)) && (o.v == 0))) return @"few";
              if (((!(o.v == 0)))) return @"many";
              return @"other";
          },
          @"ii": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"root": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"ssy": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"fo": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"tr": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"vun": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"zh": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"ts": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"lg": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"wo": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"fr": ^(CLDRPluralOperands o){
              if ((((0 <= o.i && o.i <= 1)))) return @"one";
              return @"other";
          },
          @"seh": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"in": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"bem": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"cgg": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"fur": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"tzm": ^(CLDRPluralOperands o){
              if ((((0 <= o.n && o.n <= 1))) || (((11 <= o.n && o.n <= 99)))) return @"one";
              return @"other";
          },
          @"cy": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              if (((o.n == 3))) return @"few";
              if (((o.n == 0))) return @"zero";
              if (((o.n == 2))) return @"two";
              if (((o.n == 6))) return @"many";
              return @"other";
          },
          @"syr": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"ksh": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              if (((o.n == 0))) return @"zero";
              return @"other";
          },
          @"nnh": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"wae": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"ckb": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"saq": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"af": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"da": ^(CLDRPluralOperands o){
              if (((o.n == 1)) || ((!(o.t == 0)) && ((0 <= o.i && o.i <= 1)))) return @"one";
              return @"other";
          },
          @"lkt": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"is": ^(CLDRPluralOperands o){
              if (((o.t == 0) && (fmod(o.i, 10) == 1) && (!(fmod(o.i, 100) == 11))) || ((!(o.t == 0)))) return @"one";
              return @"other";
          },
          @"ln": ^(CLDRPluralOperands o){
              if ((((0 <= o.n && o.n <= 1)))) return @"one";
              return @"other";
          },
          @"fy": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"it": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"lo": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"iu": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              if (((o.n == 2))) return @"two";
              return @"other";
          },
          @"de": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"gsw": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"iw": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              if (((o.i == 2) && (o.v == 0))) return @"two";
              if (((o.v == 0) && (!((0 <= o.n && o.n <= 10))) && (fmod(o.n, 10) == 0))) return @"many";
              return @"other";
          },
          @"ak": ^(CLDRPluralOperands o){
              if ((((0 <= o.n && o.n <= 1)))) return @"one";
              return @"other";
          },
          @"ga": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              if ((((3 <= o.n && o.n <= 6)))) return @"few";
              if (((o.n == 2))) return @"two";
              if ((((7 <= o.n && o.n <= 10)))) return @"many";
              return @"other";
          },
          @"om": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"zu": ^(CLDRPluralOperands o){
              if (((o.i == 0)) || ((o.n == 1))) return @"one";
              return @"other";
          },
          @"shi": ^(CLDRPluralOperands o){
              if (((o.i == 0)) || ((o.n == 1))) return @"one";
              if ((((2 <= o.n && o.n <= 10)))) return @"few";
              return @"other";
          },
          @"lt": ^(CLDRPluralOperands o){
              if (((fmod(o.n, 10) == 1) && (!((11 <= fmod(o.n, 100) && fmod(o.n, 100) <= 19))))) return @"one";
              if ((((2 <= fmod(o.n, 10) && fmod(o.n, 10) <= 9)) && (!((11 <= fmod(o.n, 100) && fmod(o.n, 100) <= 19))))) return @"few";
              if (((!(o.f == 0)))) return @"many";
              return @"other";
          },
          @"am": ^(CLDRPluralOperands o){
              if (((o.i == 0)) || ((o.n == 1))) return @"one";
              return @"other";
          },
          @"sma": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              if (((o.n == 2))) return @"two";
              return @"other";
          },
          @"gd": ^(CLDRPluralOperands o){
              if (((o.n == 1 || o.n == 11))) return @"one";
              if ((((3 <= o.n && o.n <= 10) || (13 <= o.n && o.n <= 19)))) return @"few";
              if (((o.n == 2 || o.n == 12))) return @"two";
              return @"other";
          },
          @"lv": ^(CLDRPluralOperands o){
              if (((fmod(o.n, 10) == 1) && (!(fmod(o.n, 100) == 11))) || ((o.v == 2) && (fmod(o.f, 10) == 1) && (!(fmod(o.f, 100) == 11))) || ((!(o.v == 2)) && (fmod(o.f, 10) == 1))) return @"one";
              if (((fmod(o.n, 10) == 0)) || (((11 <= fmod(o.n, 100) && fmod(o.n, 100) <= 19))) || ((o.v == 2) && ((11 <= fmod(o.f, 100) && fmod(o.f, 100) <= 19)))) return @"zero";
              return @"other";
          },
          @"ug": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"kab": ^(CLDRPluralOperands o){
              if ((((0 <= o.i && o.i <= 1)))) return @"one";
              return @"other";
          },
          @"or": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"ja": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"rm": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"guw": ^(CLDRPluralOperands o){
              if ((((0 <= o.n && o.n <= 1)))) return @"one";
              return @"other";
          },
          @"tig": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"os": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"asa": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"ro": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              if (((!(o.v == 0))) || ((o.n == 0)) || ((!(o.n == 1)) && ((1 <= fmod(o.n, 100) && fmod(o.n, 100) <= 19)))) return @"few";
              return @"other";
          },
          @"ar": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              if ((((3 <= fmod(o.n, 100) && fmod(o.n, 100) <= 10)))) return @"few";
              if (((o.n == 0))) return @"zero";
              if (((o.n == 2))) return @"two";
              if ((((11 <= fmod(o.n, 100) && fmod(o.n, 100) <= 99)))) return @"many";
              return @"other";
          },
          @"uk": ^(CLDRPluralOperands o){
              if (((o.v == 0) && (fmod(o.i, 10) == 1) && (!(fmod(o.i, 100) == 11)))) return @"one";
              if (((o.v == 0) && ((2 <= fmod(o.i, 10) && fmod(o.i, 10) <= 4)) && (!((12 <= fmod(o.i, 100) && fmod(o.i, 100) <= 14))))) return @"few";
              if (((o.v == 0) && (fmod(o.i, 10) == 0)) || ((o.v == 0) && ((5 <= fmod(o.i, 10) && fmod(o.i, 10) <= 9))) || ((o.v == 0) && ((11 <= fmod(o.i, 100) && fmod(o.i, 100) <= 14)))) return @"many";
              return @"other";
          },
          @"teo": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"xh": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"ses": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"gl": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"rof": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"prg": ^(CLDRPluralOperands o){
              if (((fmod(o.n, 10) == 1) && (!(fmod(o.n, 100) == 11))) || ((o.v == 2) && (fmod(o.f, 10) == 1) && (!(fmod(o.f, 100) == 11))) || ((!(o.v == 2)) && (fmod(o.f, 10) == 1))) return @"one";
              if (((fmod(o.n, 10) == 0)) || (((11 <= fmod(o.n, 100) && fmod(o.n, 100) <= 19))) || ((o.v == 2) && ((11 <= fmod(o.f, 100) && fmod(o.f, 100) <= 19)))) return @"zero";
              return @"other";
          },
          @"ru": ^(CLDRPluralOperands o){
              if (((o.v == 0) && (fmod(o.i, 10) == 1) && (!(fmod(o.i, 100) == 11)))) return @"one";
              if (((o.v == 0) && ((2 <= fmod(o.i, 10) && fmod(o.i, 10) <= 4)) && (!((12 <= fmod(o.i, 100) && fmod(o.i, 100) <= 14))))) return @"few";
              if (((o.v == 0) && (fmod(o.i, 10) == 0)) || ((o.v == 0) && ((5 <= fmod(o.i, 10) && fmod(o.i, 10) <= 9))) || ((o.v == 0) && ((11 <= fmod(o.i, 100) && fmod(o.i, 100) <= 14)))) return @"many";
              return @"other";
          },
          @"ji": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"chr": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"nqo": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"bez": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"kea": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"ur": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"az": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"pa": ^(CLDRPluralOperands o){
              if ((((0 <= o.n && o.n <= 1)))) return @"one";
              return @"other";
          },
          @"dv": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"mg": ^(CLDRPluralOperands o){
              if ((((0 <= o.n && o.n <= 1)))) return @"one";
              return @"other";
          },
          @"smi": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              if (((o.n == 2))) return @"two";
              return @"other";
          },
          @"smj": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              if (((o.n == 2))) return @"two";
              return @"other";
          },
          @"lag": ^(CLDRPluralOperands o){
              if ((((0 <= o.i && o.i <= 1)) && (!(o.n == 0)))) return @"one";
              if (((o.n == 0))) return @"zero";
              return @"other";
          },
          @"kaj": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"kde": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"kcg": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"dz": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"gu": ^(CLDRPluralOperands o){
              if (((o.i == 0)) || ((o.n == 1))) return @"one";
              return @"other";
          },
          @"mk": ^(CLDRPluralOperands o){
              if (((o.v == 0) && (fmod(o.i, 10) == 1)) || ((fmod(o.f, 10) == 1))) return @"one";
              return @"other";
          },
          @"nso": ^(CLDRPluralOperands o){
              if ((((0 <= o.n && o.n <= 1)))) return @"one";
              return @"other";
          },
          @"gv": ^(CLDRPluralOperands o){
              if (((o.v == 0) && (fmod(o.i, 10) == 1))) return @"one";
              if (((o.v == 0) && (fmod(o.i, 100) == 0 || fmod(o.i, 100) == 20 || fmod(o.i, 100) == 40 || fmod(o.i, 100) == 60 || fmod(o.i, 100) == 80))) return @"few";
              if (((o.v == 0) && (fmod(o.i, 10) == 2))) return @"two";
              if (((!(o.v == 0)))) return @"many";
              return @"other";
          },
          @"be": ^(CLDRPluralOperands o){
              if (((fmod(o.n, 10) == 1) && (!(fmod(o.n, 100) == 11)))) return @"one";
              if ((((2 <= fmod(o.n, 10) && fmod(o.n, 10) <= 4)) && (!((12 <= fmod(o.n, 100) && fmod(o.n, 100) <= 14))))) return @"few";
              if (((fmod(o.n, 10) == 0)) || (((5 <= fmod(o.n, 10) && fmod(o.n, 10) <= 9))) || (((11 <= fmod(o.n, 100) && fmod(o.n, 100) <= 14)))) return @"many";
              return @"other";
          },
          @"fil": ^(CLDRPluralOperands o){
              if (((o.v == 0) && ((1 <= o.i && o.i <= 3))) || ((o.v == 0) && (!(fmod(o.i, 10) == 4 || fmod(o.i, 10) == 6 || fmod(o.i, 10) == 9))) || ((!(o.v == 0)) && (!(fmod(o.f, 10) == 4 || fmod(o.f, 10) == 6 || fmod(o.f, 10) == 9)))) return @"one";
              return @"other";
          },
          @"ml": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"uz": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"mn": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"bg": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"mo": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              if (((!(o.v == 0))) || ((o.n == 0)) || ((!(o.n == 1)) && ((1 <= fmod(o.n, 100) && fmod(o.n, 100) <= 19)))) return @"few";
              return @"other";
          },
          @"bh": ^(CLDRPluralOperands o){
              if ((((0 <= o.n && o.n <= 1)))) return @"one";
              return @"other";
          },
          @"se": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              if (((o.n == 2))) return @"two";
              return @"other";
          },
          @"smn": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              if (((o.n == 2))) return @"two";
              return @"other";
          },
          @"jbo": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"jv": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"ee": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"pl": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              if (((o.v == 0) && ((2 <= fmod(o.i, 10) && fmod(o.i, 10) <= 4)) && (!((12 <= fmod(o.i, 100) && fmod(o.i, 100) <= 14))))) return @"few";
              if (((o.v == 0) && (!(o.i == 1)) && ((0 <= fmod(o.i, 10) && fmod(o.i, 10) <= 1))) || ((o.v == 0) && ((5 <= fmod(o.i, 10) && fmod(o.i, 10) <= 9))) || ((o.v == 0) && ((12 <= fmod(o.i, 100) && fmod(o.i, 100) <= 14)))) return @"many";
              return @"other";
          },
          @"sg": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"haw": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"ha": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"jw": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"mr": ^(CLDRPluralOperands o){
              if (((o.i == 0)) || ((o.n == 1))) return @"one";
              return @"other";
          },
          @"sh": ^(CLDRPluralOperands o){
              if (((o.v == 0) && (fmod(o.i, 10) == 1) && (!(fmod(o.i, 100) == 11))) || ((fmod(o.f, 10) == 1) && (!(fmod(o.f, 100) == 11)))) return @"one";
              if (((o.v == 0) && ((2 <= fmod(o.i, 10) && fmod(o.i, 10) <= 4)) && (!((12 <= fmod(o.i, 100) && fmod(o.i, 100) <= 14)))) || (((2 <= fmod(o.f, 10) && fmod(o.f, 10) <= 4)) && (!((12 <= fmod(o.f, 100) && fmod(o.f, 100) <= 14))))) return @"few";
              return @"other";
          },
          @"ms": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"si": ^(CLDRPluralOperands o){
              if ((((0 <= o.n && o.n <= 1))) || ((o.i == 0) && (o.f == 1))) return @"one";
              return @"other";
          },
          @"mt": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              if (((o.n == 0)) || (((2 <= fmod(o.n, 100) && fmod(o.n, 100) <= 10)))) return @"few";
              if ((((11 <= fmod(o.n, 100) && fmod(o.n, 100) <= 19)))) return @"many";
              return @"other";
          },
          @"bm": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"ve": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"nah": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"bn": ^(CLDRPluralOperands o){
              if (((o.i == 0)) || ((o.n == 1))) return @"one";
              return @"other";
          },
          @"sk": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              if ((((2 <= o.i && o.i <= 4)) && (o.v == 0))) return @"few";
              if (((!(o.v == 0)))) return @"many";
              return @"other";
          },
          @"sl": ^(CLDRPluralOperands o){
              if (((o.v == 0) && (fmod(o.i, 100) == 1))) return @"one";
              if (((o.v == 0) && ((3 <= fmod(o.i, 100) && fmod(o.i, 100) <= 4))) || ((!(o.v == 0)))) return @"few";
              if (((o.v == 0) && (fmod(o.i, 100) == 2))) return @"two";
              return @"other";
          },
          @"bo": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"he": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              if (((o.i == 2) && (o.v == 0))) return @"two";
              if (((o.v == 0) && (!((0 <= o.n && o.n <= 10))) && (fmod(o.n, 10) == 0))) return @"many";
              return @"other";
          },
          @"ka": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"ps": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"el": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"sn": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"vi": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"my": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"br": ^(CLDRPluralOperands o){
              if (((fmod(o.n, 10) == 1) && (!(fmod(o.n, 100) == 11 || fmod(o.n, 100) == 71 || fmod(o.n, 100) == 91)))) return @"one";
              if ((((3 <= fmod(o.n, 10) && fmod(o.n, 10) <= 4) || fmod(o.n, 10) == 9) && (!((10 <= fmod(o.n, 100) && fmod(o.n, 100) <= 19) || (70 <= fmod(o.n, 100) && fmod(o.n, 100) <= 79) || (90 <= fmod(o.n, 100) && fmod(o.n, 100) <= 99))))) return @"few";
              if (((fmod(o.n, 10) == 2) && (!(fmod(o.n, 100) == 12 || fmod(o.n, 100) == 72 || fmod(o.n, 100) == 92)))) return @"two";
              if (((!(o.n == 0)) && (fmod(o.n, 1000000) == 0))) return @"many";
              return @"other";
          },
          @"pt": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0)) || ((o.i == 0) && (o.t == 1))) return @"one";
              return @"other";
          },
          @"sms": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              if (((o.n == 2))) return @"two";
              return @"other";
          },
          @"so": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"bs": ^(CLDRPluralOperands o){
              if (((o.v == 0) && (fmod(o.i, 10) == 1) && (!(fmod(o.i, 100) == 11))) || ((fmod(o.f, 10) == 1) && (!(fmod(o.f, 100) == 11)))) return @"one";
              if (((o.v == 0) && ((2 <= fmod(o.i, 10) && fmod(o.i, 10) <= 4)) && (!((12 <= fmod(o.i, 100) && fmod(o.i, 100) <= 14)))) || (((2 <= fmod(o.f, 10) && fmod(o.f, 10) <= 4)) && (!((12 <= fmod(o.f, 100) && fmod(o.f, 100) <= 14))))) return @"few";
              return @"other";
          },
          @"en": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"hi": ^(CLDRPluralOperands o){
              if (((o.i == 0)) || ((o.n == 1))) return @"one";
              return @"other";
          },
          @"sq": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"eo": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"nyn": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"jmc": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"sr": ^(CLDRPluralOperands o){
              if (((o.v == 0) && (fmod(o.i, 10) == 1) && (!(fmod(o.i, 100) == 11))) || ((fmod(o.f, 10) == 1) && (!(fmod(o.f, 100) == 11)))) return @"one";
              if (((o.v == 0) && ((2 <= fmod(o.i, 10) && fmod(o.i, 10) <= 4)) && (!((12 <= fmod(o.i, 100) && fmod(o.i, 100) <= 14)))) || (((2 <= fmod(o.f, 10) && fmod(o.f, 10) <= 4)) && (!((12 <= fmod(o.f, 100) && fmod(o.f, 100) <= 14))))) return @"few";
              return @"other";
          },
          @"ss": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"nb": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"yi": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"st": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"vo": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"es": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"nd": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"ast": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"jgo": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"sv": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"et": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"ne": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"sw": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"eu": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"kk": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"kl": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"xog": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"yo": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"hr": ^(CLDRPluralOperands o){
              if (((o.v == 0) && (fmod(o.i, 10) == 1) && (!(fmod(o.i, 100) == 11))) || ((fmod(o.f, 10) == 1) && (!(fmod(o.f, 100) == 11)))) return @"one";
              if (((o.v == 0) && ((2 <= fmod(o.i, 10) && fmod(o.i, 10) <= 4)) && (!((12 <= fmod(o.i, 100) && fmod(o.i, 100) <= 14)))) || (((2 <= fmod(o.f, 10) && fmod(o.f, 10) <= 4)) && (!((12 <= fmod(o.f, 100) && fmod(o.f, 100) <= 14))))) return @"few";
              return @"other";
          },
          @"ca": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"km": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"mas": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"rwk": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"kn": ^(CLDRPluralOperands o){
              if (((o.i == 0)) || ((o.n == 1))) return @"one";
              return @"other";
          },
          @"ko": ^(CLDRPluralOperands o){
              return @"other";
          },
          @"naq": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              if (((o.n == 2))) return @"two";
              return @"other";
          },
          @"pt-PT": ^(CLDRPluralOperands o){
              if (((o.n == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"hu": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"ta": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
          @"nl": ^(CLDRPluralOperands o){
              if (((o.i == 1) && (o.v == 0))) return @"one";
              return @"other";
          },
          @"kkj": ^(CLDRPluralOperands o){
              if (((o.n == 1))) return @"one";
              return @"other";
          },
        };
    });
    return rules;
}

CLDRPluralRuleBlock CLDRPluralRuleForLanguage(NSString * language) {
    return CLDRPluralRules()[language];
}

NSString * plural(NSString * language, NSString * number, NSDictionary * options) {
    if (!language || !number) return nil;
    
    CLDRPluralRuleBlock rule = CLDRPluralRuleForLanguage(language);
    if (!rule) return nil;
    
    CLDRPluralOperands operands = OperandsFromString(number, options);
    return rule(operands);
}

#pragma mark -

typedef NS_ENUM(NSUInteger, TokenType) {
    TokenTypeNone = 0,
    TokenTypeOperand,
    TokenTypeValue,
    TokenTypeInteger,
    TokenTypeDecimal,
    TokenTypeAnd,
    TokenTypeOr,
    TokenTypeNot,
    TokenTypeMod,
    TokenTypeIs,
    TokenTypeIn,
    TokenTypeWithin,
    TokenTypeDot,
    TokenTypeDotDot,
    TokenTypeComma,
    TokenTypeEllipsis,
    TokenTypeTilde,
};

@interface Token : NSObject

@property (assign) TokenType type;
@property (copy) NSString * value;

@end
@implementation Token

+ (instancetype)tokenWithType:(TokenType)type value:(NSString *)value {
    Token * token = [[Token alloc] init];
    token.type = type;
    token.value = value;
    return token;
}

- (NSString *)typeDescription {
    switch (self.type) {
        case TokenTypeNone: return @"None";
        case TokenTypeOperand: return @"Operand";
        case TokenTypeValue: return @"Value";
        case TokenTypeInteger: return @"Integer";
        case TokenTypeDecimal: return @"Decimal";
        case TokenTypeAnd: return @"And";
        case TokenTypeOr: return @"Or";
        case TokenTypeNot: return @"Not";
        case TokenTypeMod: return @"Mod";
        case TokenTypeIs: return @"Is";
        case TokenTypeIn: return @"In";
        case TokenTypeWithin: return @"Within";
        case TokenTypeDot: return @"Dot";
        case TokenTypeDotDot: return @"DotDot";
        case TokenTypeComma: return @"Comma";
        case TokenTypeEllipsis: return @"Ellipsis";
        case TokenTypeTilde: return @"Tilde";
    }
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: 0x%lx; type=%@; value='%@'>", [self class], (unsigned long)self, [self typeDescription], self.value];
}

@end

@interface LexicalAnalyzer : NSObject
@end
@implementation LexicalAnalyzer

+ (NSArray *)analyze:(NSString *)ruleSource {
    NSMutableArray * tokens = [[NSMutableArray alloc] init];
    
    NSUInteger length = [ruleSource length];
    for (NSUInteger i = 0; i < length; i++) {
        switch ([ruleSource characterAtIndex:i]) {
            case ' ':
            case '\t':
            case '\n':
                break;
                
            case '@': {
                if (i+7 < length) {
                    NSString * value = [ruleSource substringWithRange:NSMakeRange(i, 8)];
                    if ([value isEqualToString:@"@integer"]) {
                        [tokens addObject:[Token tokenWithType:TokenTypeInteger value:value]];
                        i += 7;
                    } else if ([value isEqualToString:@"@decimal"]) {
                        [tokens addObject:[Token tokenWithType:TokenTypeDecimal value:value]];
                        i += 7;
                    } else {
                        [tokens addObject:[Token tokenWithType:TokenTypeNone value:@"@"]];
                    }
                } else {
                    [tokens addObject:[Token tokenWithType:TokenTypeNone value:@"@"]];
                }
            } break;
                
            case 0x2026: {
                [tokens addObject:[Token tokenWithType:TokenTypeEllipsis value:@"…"]];
            } break;
                
            case '%': {
                [tokens addObject:[Token tokenWithType:TokenTypeMod value:@"%"]];
            } break;
                
            case ',': {
                [tokens addObject:[Token tokenWithType:TokenTypeComma value:@","]];
            } break;
                
            case '~': {
                [tokens addObject:[Token tokenWithType:TokenTypeTilde value:@"~"]];
            } break;
                
            case '=': {
                [tokens addObject:[Token tokenWithType:TokenTypeIn value:@"="]];
            } break;
                
            case '!': {
                [tokens addObject:[Token tokenWithType:TokenTypeNot value:@"!"]];
            } break;
                
            case '.': {
                if (i+1 >= length || [ruleSource characterAtIndex:i+1] != '.') {
                    [tokens addObject:[Token tokenWithType:TokenTypeDot value:@"."]];
                } else if (i+2 >= length || [ruleSource characterAtIndex:i+2] != '.') {
                    [tokens addObject:[Token tokenWithType:TokenTypeDotDot value:@".."]];
                    i += 1;
                } else {
                    [tokens addObject:[Token tokenWithType:TokenTypeEllipsis value:@"..."]];
                    i += 2;
                }
            } break;
                
            case 'a': {
                if (i+2 < length && [[ruleSource substringWithRange:NSMakeRange(i, 3)] isEqualToString:@"and"]) {
                    [tokens addObject:[Token tokenWithType:TokenTypeAnd value:@"and"]];
                    i += 2;
                } else {
                    [tokens addObject:[Token tokenWithType:TokenTypeNone value:@"a"]];
                }
            } break;
                
            case 'o': {
                if (i+1 < length && [[ruleSource substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"or"]) {
                    [tokens addObject:[Token tokenWithType:TokenTypeOr value:@"or"]];
                    i += 1;
                } else {
                    [tokens addObject:[Token tokenWithType:TokenTypeNone value:@"o"]];
                }
            } break;
                
            case 'm': {
                if (i+2 < length && [[ruleSource substringWithRange:NSMakeRange(i, 3)] isEqualToString:@"mod"]) {
                    [tokens addObject:[Token tokenWithType:TokenTypeMod value:@"mod"]];
                    i += 2;
                } else {
                    [tokens addObject:[Token tokenWithType:TokenTypeNone value:@"m"]];
                }
            } break;
                
            case 'n': {
                if (i+2 < length && [[ruleSource substringWithRange:NSMakeRange(i, 3)] isEqualToString:@"not"]) {
                    [tokens addObject:[Token tokenWithType:TokenTypeNot value:@"not"]];
                    i += 2;
                } else {
                    [tokens addObject:[Token tokenWithType:TokenTypeOperand value:@"n"]];
                }
            } break;
                
            case 'i': {
                if (i+1 < length) {
                    NSString * value = [ruleSource substringWithRange:NSMakeRange(i, 2)];
                    if ([value isEqualToString:@"is"]) {
                        [tokens addObject:[Token tokenWithType:TokenTypeIs value:value]];
                        i += 1;
                    } else if ([value isEqualToString:@"in"]) {
                        [tokens addObject:[Token tokenWithType:TokenTypeIn value:value]];
                        i += 1;
                    } else {
                        [tokens addObject:[Token tokenWithType:TokenTypeOperand value:@"i"]];
                    }
                } else {
                    [tokens addObject:[Token tokenWithType:TokenTypeOperand value:@"i"]];
                }
            } break;
                
            case 'w': {
                if (i+5 < length && [[ruleSource substringWithRange:NSMakeRange(i, 6)] isEqualToString:@"within"]) {
                    [tokens addObject:[Token tokenWithType:TokenTypeWithin value:@"within"]];
                    i += 5;
                } else {
                    [tokens addObject:[Token tokenWithType:TokenTypeOperand value:@"w"]];
                }
            } break;
                
            case 'v':
            case 'f':
            case 't': {
                NSString * value = [ruleSource substringWithRange:NSMakeRange(i, 1)];
                [tokens addObject:[Token tokenWithType:TokenTypeOperand value:value]];
            } break;
                
            default: {
                NSUInteger numberLength = 0;
                unichar character = [ruleSource characterAtIndex:i];
                while (character >= '0' && character <= '9') {
                    numberLength++;
                    character = (i+numberLength < length) ? [ruleSource characterAtIndex:i+numberLength] : 0;
                }
                
                if (numberLength > 0) {
                    NSString * value = [ruleSource substringWithRange:NSMakeRange(i, numberLength)];
                    [tokens addObject:[Token tokenWithType:TokenTypeValue value:value]];
                    i += numberLength - 1;
                } else {
                    NSString * value = [ruleSource substringWithRange:NSMakeRange(i, 1)];
                    [tokens addObject:[Token tokenWithType:TokenTypeNone value:value]];
                }
            } break;
        }
    }
    
    return tokens;
}

@end

@interface RangeList : NSObject
@property (strong) NSIndexSet * values;
@end
@implementation RangeList

+ (RangeList *)rangeListFromTokens:(NSArray *)tokens atIndex:(NSUInteger *)index {
    NSMutableIndexSet * values = [[NSMutableIndexSet alloc] init];
    while (1) {
        Token * token = (*index < [tokens count]) ? tokens[*index] : nil;
        if (token.type != TokenTypeValue) break;
        *index += 1;
        
        if (*index < [tokens count] && [(Token *)tokens[*index] type] == TokenTypeDotDot) {
            *index += 1;
            Token * other = (*index < [tokens count]) ? tokens[*index] : nil;
            if (other.type != TokenTypeValue) break;
            *index += 1;
            
            NSUInteger start = [token.value integerValue];
            NSUInteger end = [other.value integerValue];
            [values addIndexesInRange:NSMakeRange(start, end-start+1)];
        } else {
            [values addIndex:[token.value integerValue]];
        }
        
        if (!(*index < [tokens count] && [(Token *)tokens[*index] type] == TokenTypeComma)) break;
        
        *index += 1;
    }
    
    if ([values count] == 0) return nil;
    
    RangeList * rangeList = [[RangeList alloc] init];
    rangeList.values = values;
    
    return rangeList;
}

- (NSString *)description {
    NSMutableString * description = [[NSMutableString alloc] init];
    [self.values enumerateRangesUsingBlock:^(NSRange range, BOOL *stop) {
        if ([description length] > 0) {
            [description appendString:@", "];
        }
        if (range.length == 1) {
            [description appendString:[@(range.location) stringValue]];
        } else {
            [description appendFormat:@"%@..%@", [@(range.location) stringValue], [@(NSMaxRange(range)-1) stringValue]];
        }
    }];
    return description;
}

@end

@interface SampleRange : NSObject
@property (copy) NSString * start;
@property (copy) NSString * end;
@end
@implementation SampleRange

+ (NSString *)decimalFromTokens:(NSArray *)tokens atIndex:(NSUInteger *)index {
    BOOL foundDot = NO;
    NSMutableString * value = [[NSMutableString alloc] init];
    Token * token = (*index < [tokens count]) ? tokens[*index] : nil;
    while (token.type == TokenTypeValue || (!foundDot && token.type == TokenTypeDot)) {
        if (token.type == TokenTypeDot) {
            foundDot = YES;
        }
        *index += 1;
        [value appendString:token.value];
        token = (*index < [tokens count]) ? tokens[*index] : nil;
    }
    return value;
}

+ (SampleRange *)sampleRangeWithTokens:(NSArray *)tokens atIndex:(NSUInteger *)index {
    SampleRange * sampleRange = [[SampleRange alloc] init];
    
    if (!(*index < [tokens count] && [(Token *)tokens[*index] type] == TokenTypeValue)) return nil;
    
    sampleRange.start = [self decimalFromTokens:tokens atIndex:index];
    
    if (*index < [tokens count] && [(Token *)tokens[*index] type] == TokenTypeTilde) {
        *index += 1;
        if (!(*index < [tokens count] && [(Token *)tokens[*index] type] == TokenTypeValue)) return nil;
        sampleRange.end = [self decimalFromTokens:tokens atIndex:index];
    }
    
    return sampleRange;
}

- (NSString *)description {
    NSMutableString * description = [[NSMutableString alloc] initWithString:self.start];
    if (self.end) {
        [description appendFormat:@"~%@", self.end];
    }
    return description;
}

@end

@interface Relation : NSObject
@property (strong) NSString * operand;
@property (strong) NSString * modValue;
@property (assign) BOOL not;
@property (strong) Token * operation;
@property (strong) RangeList * rangeList;
@end
@implementation Relation

+ (Relation *)relationWithTokens:(NSArray *)tokens atIndex:(NSUInteger *)index {
    BOOL not = NO;
    
    Token * operand = (*index < [tokens count]) ? tokens[*index] : nil;
    if (operand.type != TokenTypeOperand) return nil;
    *index += 1;
    
    Token * modValue = nil;
    if (*index < [tokens count] && [(Token *)tokens[*index] type] == TokenTypeMod) {
        *index += 1;
        modValue = (*index < [tokens count]) ? tokens[*index] : nil;
        if (modValue.type != TokenTypeValue) return nil;
        *index += 1;
    }
    
    Token * operation = (*index < [tokens count]) ? tokens[*index] : nil;
    if (operation.type == TokenTypeNot) {
        *index += 1;
        not = YES;
        operation = (*index < [tokens count]) ? tokens[*index] : nil;
    }
    *index += 1;
    
    if (*index < [tokens count] && [(Token *)tokens[*index] type] == TokenTypeNot) {
        *index += 1;
        not = YES;
    }
    
    RangeList * rangeList = [RangeList rangeListFromTokens:tokens atIndex:index];
    if (!rangeList) return nil;
    
    Relation * relation = [[Relation alloc] init];
    relation.operand = operand.value;
    relation.modValue = modValue.value;
    relation.not = not;
    relation.operation = operation;
    relation.rangeList = rangeList;
    
    return relation;
}

- (NSString *)description {
    NSMutableString * description = [[NSMutableString alloc] initWithString:self.operand];
    if (self.modValue) {
        [description appendFormat:@" %% %@", self.modValue];
    }
    switch (self.operation.type) {
        case TokenTypeIs: {
            [description appendFormat:@" is%@ ", (self.not ? @" not" : @"")];
        } break;
        case TokenTypeIn: {
            [description appendFormat:@" %@= ", (self.not ? @"!" : @"")];
        } break;
        case TokenTypeWithin: {
            [description appendFormat:@" %@within ", (self.not ? @"not " : @"")];
        } break;
        default:
            break;
    }
    [description appendString:[self.rangeList description]];
    return description;
}

- (NSString *)code {
    NSString * operand = nil;
    if (self.modValue) {
        operand = [[NSString alloc] initWithFormat:@"fmod(o.%@, %@)", self.operand, self.modValue];
    } else {
        operand = [[NSString alloc] initWithFormat:@"o.%@", self.operand];
    }
    
    NSMutableString * code = [[NSMutableString alloc] init];
    [self.rangeList.values enumerateRangesUsingBlock:^(NSRange range, BOOL *stop) {
        if ([code length] > 0) {
            [code appendString:@" || "];
        }
        if (range.length == 1) {
            [code appendFormat:@"%@ == %@", operand, [@(range.location) stringValue]];
        } else {
            [code appendFormat:@"(%@ <= %@ && %@ <= %@)", [@(range.location) stringValue], operand, operand, [@(NSMaxRange(range)-1) stringValue]];
        }
    }];
    
    if (self.not) {
        return [NSString stringWithFormat:@"!(%@)", code];
    }
    return code;
}

@end

@interface SampleList : NSObject
@property (strong) NSArray * sampleRanges;
@property (assign) BOOL infinite;
@end
@implementation SampleList

+ (SampleList *)sampleListWithTokens:(NSArray *)tokens atIndex:(NSUInteger *)index {
    BOOL infinite = NO;
    NSMutableArray * sampleRanges = [[NSMutableArray alloc] init];
    while (1) {
        SampleRange * sampleRange = [SampleRange sampleRangeWithTokens:tokens atIndex:index];
        if (!sampleRange) break;
        
        [sampleRanges addObject:sampleRange];
        if (!(*index < [tokens count] && [(Token *)tokens[*index] type] == TokenTypeComma)) break;
        
        *index += 1;
        
        if (*index < [tokens count] && [(Token *)tokens[*index] type] == TokenTypeEllipsis) {
            *index += 1;
            infinite = YES;
            break;
        }
    }
    
    if ([sampleRanges count] == 0) return nil;
    
    SampleList * sampleList = [[SampleList alloc] init];
    sampleList.sampleRanges = sampleRanges;
    sampleList.infinite = infinite;
    
    return sampleList;
}

- (NSString *)description {
    NSMutableString * description = [[NSMutableString alloc] init];
    for (SampleRange * sampleRange in self.sampleRanges) {
        if ([description length] > 0) {
            [description appendString:@", "];
        }
        [description appendString:[sampleRange description]];
    }
    if (self.infinite) {
        if ([description length] > 0) {
            [description appendString:@", "];
        }
        [description appendString:@"…"];
    }
    return description;
}

@end

@interface AndCondition : NSObject
@property (strong) NSArray * relations;
@end
@implementation AndCondition

+ (AndCondition *)andConditionWithTokens:(NSArray *)tokens atIndex:(NSUInteger *)index {
    NSMutableArray * relations = [[NSMutableArray alloc] init];
    while (1) {
        Relation * relation = [Relation relationWithTokens:tokens atIndex:index];
        if (!relation) break;
        
        [relations addObject:relation];
        if (!(*index < [tokens count] && [(Token *)tokens[*index] type] == TokenTypeAnd)) break;
        
        *index += 1;
    }
    
    if ([relations count] == 0) return nil;
    
    AndCondition * andCondition = [[AndCondition alloc] init];
    andCondition.relations = relations;
    
    return andCondition;
}

- (NSString *)description {
    NSMutableString * description = [[NSMutableString alloc] init];
    for (Relation * relation in self.relations) {
        if ([description length] > 0) {
            [description appendString:@" and "];
        }
        [description appendString:[relation description]];
    }
    return description;
}

- (NSString *)code {
    NSMutableString * code = [[NSMutableString alloc] init];
    for (Relation * relation in self.relations) {
        if ([code length] > 0) {
            [code appendString:@" && "];
        }
        [code appendFormat:@"(%@)", [relation code]];
    }
    return code;
}

@end

@interface Condition : NSObject
@property (strong) NSArray * andConditions;
@end
@implementation Condition

+ (Condition *)conditionWithTokens:(NSArray *)tokens atIndex:(NSUInteger *)index {
    NSMutableArray * andConditions = [[NSMutableArray alloc] init];
    while (1) {
        AndCondition * andCondition = [AndCondition andConditionWithTokens:tokens atIndex:index];
        if (!andCondition) break;
        
        [andConditions addObject:andCondition];
        if (!(*index < [tokens count] && [(Token *)tokens[*index] type] == TokenTypeOr)) break;
        
        *index += 1;
    }
    
    if ([andConditions count] == 0) return nil;
    
    Condition * condition = [[Condition alloc] init];
    condition.andConditions = andConditions;
    
    return condition;
}

- (NSString *)description {
    NSMutableString * description = [[NSMutableString alloc] init];
    for (AndCondition * andCondition in self.andConditions) {
        if ([description length] > 0) {
            [description appendString:@" or "];
        }
        [description appendString:[andCondition description]];
    }
    return description;
}

- (NSString *)code {
    NSMutableString * code = [[NSMutableString alloc] init];
    for (AndCondition * andCondition in self.andConditions) {
        if ([code length] > 0) {
            [code appendString:@" || "];
        }
        [code appendFormat:@"(%@)", [andCondition code]];
    }
    return code;
}

@end

@interface Sample : NSObject
@property (strong) SampleList * integerSampleList;
@property (strong) SampleList * decimalSampleList;
@end
@implementation Sample

+ (Sample *)samplesWithTokens:(NSArray *)tokens atIndex:(NSUInteger *)index {
    Sample * sample = [[Sample alloc] init];
    
    Token * token = (*index < [tokens count]) ? tokens[*index] : nil;
    
    if (token.type == TokenTypeInteger) {
        *index += 1;
        sample.integerSampleList = [SampleList sampleListWithTokens:tokens atIndex:index];
        token = (*index < [tokens count]) ? tokens[*index] : nil;
    }
    
    if (token.type == TokenTypeDecimal) {
        *index += 1;
        sample.decimalSampleList = [SampleList sampleListWithTokens:tokens atIndex:index];
    }
    
    if (!(sample.integerSampleList || sample.decimalSampleList)) return nil;
    
    return sample;
}

- (NSString *)description {
    NSMutableString * description = [[NSMutableString alloc] init];
    if (self.integerSampleList) {
        [description appendFormat:@"@integer %@", self.integerSampleList];
    }
    if (self.decimalSampleList) {
        if (self.integerSampleList) {
            [description appendString:@" "];
        }
        [description appendFormat:@"@decimal %@", self.decimalSampleList];
    }
    return description;
}

@end

@interface Rule : NSObject
@property (strong) Condition * condition;
@property (strong) Sample * sample;
@end
@implementation Rule

+ (Rule *)ruleWithTokens:(NSArray *)tokens atIndex:(NSUInteger *)index {
    Condition * condition = [Condition conditionWithTokens:tokens atIndex:index];
    if (!condition) return nil;
    
    Rule * rule = [[Rule alloc] init];
    rule.condition = condition;
    rule.sample = [Sample samplesWithTokens:tokens atIndex:index];
    
    return rule;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", self.condition, self.sample];
}

- (NSString *)code {
    return [self.condition code];
}

@end

#pragma mark -

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSLog(@"%@", plural(@"be", @"61", nil));
        NSLog(@"%@", plural(@"be", @"22.0", nil));
        NSLog(@"%@", plural(@"be", @"11.0", nil));
        NSLog(@"%@", plural(@"be", @"1.03", nil));
        NSLog(@"%@", plural(@"be", @"-1,230", @{CLDRPluralRuleOptionDecimalSeparator: @","}));
        
        
        NSData * data = [[NSData alloc] initWithContentsOfFile:@"/Users/cmkilger/Downloads/json/supplemental/plurals.json"];
        NSDictionary * input = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"supplemental"][@"plurals-type-cardinal"];
        
        NSMutableString * code = [[NSMutableString alloc] initWithString:@"rules = @{\n"];
        [input enumerateKeysAndObjectsUsingBlock:^(id language, id rules, BOOL *stop) {
            [code appendFormat:@"    @\"%@\": ^(CLDRPluralOperands o){\n", language];
            [rules enumerateKeysAndObjectsUsingBlock:^(id key, id rule, BOOL *stop) {
                if ([key isEqualToString:@"pluralRule-count-other"]) return;
                    
                NSArray * tokens = [LexicalAnalyzer analyze:rule];
                if (!tokens) {
                    NSLog(@"Error parsing rule: %@:%@", language, key);
                    return;
                }
                
                NSUInteger index = 0;
                NSString * logic = [[Rule ruleWithTokens:tokens atIndex:&index] code];
                if (index != [tokens count]) {
                    NSLog(@"Error parsing rule: %@:%@ :at location: %@", language, key, @(index));
                    return;
                }
                
                [code appendFormat:@"        if (%@) return @\"%@\";\n", logic, [[key componentsSeparatedByString:@"-"] lastObject]];
            }];
            [code appendString:@"        return @\"other\";\n"];
            [code appendString:@"    },\n"];
        }];
        [code appendString:@"};\n"];
        
        return 0;
    }
}