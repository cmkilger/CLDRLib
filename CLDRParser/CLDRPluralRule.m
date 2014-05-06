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
        rules = @{
              @"fa": ^(CLDRPluralOperands * o){
                  if (o.i == 0 || o.n == 1) return @"one";
                  return @"other";
              },
              @"brx": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"ks": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"nn": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"hy": ^(CLDRPluralOperands * o){
                  if ((o.i <= 1)) return @"one";
                  return @"other";
              },
              @"no": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"te": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"ku": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"wa": ^(CLDRPluralOperands * o){
                  if (((o.n <= 1 && o.f == 0))) return @"one";
                  return @"other";
              },
              @"kw": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  if (o.n == 2) return @"two";
                  return @"other";
              },
              @"ff": ^(CLDRPluralOperands * o){
                  if ((o.i <= 1)) return @"one";
                  return @"other";
              },
              @"nr": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"pap": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"sah": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"th": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"ti": ^(CLDRPluralOperands * o){
                  if (((o.n <= 1 && o.f == 0))) return @"one";
                  return @"other";
              },
              @"mgo": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"ky": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"tk": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"fi": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"id": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"ksb": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"tl": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.i, 10), a2 = fmod(o.f, 10);
                  if ((o.v == 0 && ((1 <= o.i && o.i <= 3))) || (o.v == 0 && !(a1 == 4 || a1 == 6 || a1 == 9)) || (!(o.v == 0) && !(a2 == 4 || a2 == 6 || a2 == 9))) return @"one";
                  return @"other";
              },
              @"tn": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"ig": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"lb": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"ny": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"to": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"cs": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  if ((((2 <= o.i && o.i <= 4)) && o.v == 0)) return @"few";
                  if (!(o.v == 0)) return @"many";
                  return @"other";
              },
              @"ii": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"root": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"ssy": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"fo": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"tr": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"vun": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"zh": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"ts": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"lg": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"wo": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"fr": ^(CLDRPluralOperands * o){
                  if ((o.i <= 1)) return @"one";
                  return @"other";
              },
              @"seh": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"in": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"bem": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"cgg": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"fur": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"tzm": ^(CLDRPluralOperands * o){
                  if (((o.n <= 1 && o.f == 0)) || ((11 <= o.n && o.n <= 99 && o.f == 0))) return @"one";
                  return @"other";
              },
              @"cy": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  if (o.n == 3) return @"few";
                  if (o.n == 0) return @"zero";
                  if (o.n == 2) return @"two";
                  if (o.n == 6) return @"many";
                  return @"other";
              },
              @"syr": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"ksh": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  if (o.n == 0) return @"zero";
                  return @"other";
              },
              @"nnh": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"wae": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"ckb": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"saq": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"af": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"da": ^(CLDRPluralOperands * o){
                  if (o.n == 1 || (!(o.t == 0) && (o.i <= 1))) return @"one";
                  return @"other";
              },
              @"lkt": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"is": ^(CLDRPluralOperands * o){
                  if ((o.t == 0 && fmod(o.i, 10) == 1 && !(fmod(o.i, 100) == 11)) || !(o.t == 0)) return @"one";
                  return @"other";
              },
              @"ln": ^(CLDRPluralOperands * o){
                  if (((o.n <= 1 && o.f == 0))) return @"one";
                  return @"other";
              },
              @"fy": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"it": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"lo": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"iu": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  if (o.n == 2) return @"two";
                  return @"other";
              },
              @"de": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"gsw": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"iw": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  if ((o.i == 2 && o.v == 0)) return @"two";
                  if ((o.v == 0 && !((o.n <= 10 && o.f == 0)) && fmod(o.n, 10) == 0)) return @"many";
                  return @"other";
              },
              @"ak": ^(CLDRPluralOperands * o){
                  if (((o.n <= 1 && o.f == 0))) return @"one";
                  return @"other";
              },
              @"ga": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  if (((3 <= o.n && o.n <= 6 && o.f == 0))) return @"few";
                  if (o.n == 2) return @"two";
                  if (((7 <= o.n && o.n <= 10 && o.f == 0))) return @"many";
                  return @"other";
              },
              @"om": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"zu": ^(CLDRPluralOperands * o){
                  if (o.i == 0 || o.n == 1) return @"one";
                  return @"other";
              },
              @"shi": ^(CLDRPluralOperands * o){
                  if (o.i == 0 || o.n == 1) return @"one";
                  if (((2 <= o.n && o.n <= 10 && o.f == 0))) return @"few";
                  return @"other";
              },
              @"lt": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.n, 100), a2 = fmod(o.n, 10);
                  if ((a2 == 1 && !((11 <= a1 && a1 <= 19 && o.f == 0)))) return @"one";
                  if ((((2 <= a2 && a2 <= 9 && o.f == 0)) && !((11 <= a1 && a1 <= 19 && o.f == 0)))) return @"few";
                  if (!(o.f == 0)) return @"many";
                  return @"other";
              },
              @"am": ^(CLDRPluralOperands * o){
                  if (o.i == 0 || o.n == 1) return @"one";
                  return @"other";
              },
              @"sma": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  if (o.n == 2) return @"two";
                  return @"other";
              },
              @"gd": ^(CLDRPluralOperands * o){
                  if ((o.n == 1 || o.n == 11)) return @"one";
                  if (((3 <= o.n && o.n <= 10 && o.f == 0) || (13 <= o.n && o.n <= 19 && o.f == 0))) return @"few";
                  if ((o.n == 2 || o.n == 12)) return @"two";
                  return @"other";
              },
              @"lv": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.n, 100), a2 = fmod(o.n, 10), a3 = fmod(o.f, 10), a4 = fmod(o.f, 100);
                  if ((a2 == 1 && !(a1 == 11)) || (o.v == 2 && a3 == 1 && !(a4 == 11)) || (!(o.v == 2) && a3 == 1)) return @"one";
                  if (a2 == 0 || ((11 <= a1 && a1 <= 19 && o.f == 0)) || (o.v == 2 && ((11 <= a4 && a4 <= 19)))) return @"zero";
                  return @"other";
              },
              @"ug": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"kab": ^(CLDRPluralOperands * o){
                  if ((o.i <= 1)) return @"one";
                  return @"other";
              },
              @"or": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"ja": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"rm": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"guw": ^(CLDRPluralOperands * o){
                  if (((o.n <= 1 && o.f == 0))) return @"one";
                  return @"other";
              },
              @"tig": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"os": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"asa": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"ro": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.n, 100);
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  if (!(o.v == 0) || o.n == 0 || (!(o.n == 1) && ((1 <= a1 && a1 <= 19 && o.f == 0)))) return @"few";
                  return @"other";
              },
              @"ar": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.n, 100);
                  if (o.n == 1) return @"one";
                  if (((3 <= a1 && a1 <= 10 && o.f == 0))) return @"few";
                  if (o.n == 0) return @"zero";
                  if (o.n == 2) return @"two";
                  if (((11 <= a1 && a1 <= 99 && o.f == 0))) return @"many";
                  return @"other";
              },
              @"uk": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.i, 100), a2 = fmod(o.i, 10);
                  if ((o.v == 0 && a2 == 1 && !(a1 == 11))) return @"one";
                  if ((o.v == 0 && ((2 <= a2 && a2 <= 4)) && !((12 <= a1 && a1 <= 14)))) return @"few";
                  if ((o.v == 0 && a2 == 0) || (o.v == 0 && ((5 <= a2 && a2 <= 9))) || (o.v == 0 && ((11 <= a1 && a1 <= 14)))) return @"many";
                  return @"other";
              },
              @"teo": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"xh": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"ses": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"gl": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"rof": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"prg": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.n, 100), a2 = fmod(o.n, 10), a3 = fmod(o.f, 10), a4 = fmod(o.f, 100);
                  if ((a2 == 1 && !(a1 == 11)) || (o.v == 2 && a3 == 1 && !(a4 == 11)) || (!(o.v == 2) && a3 == 1)) return @"one";
                  if (a2 == 0 || ((11 <= a1 && a1 <= 19 && o.f == 0)) || (o.v == 2 && ((11 <= a4 && a4 <= 19)))) return @"zero";
                  return @"other";
              },
              @"ru": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.i, 100), a2 = fmod(o.i, 10);
                  if ((o.v == 0 && a2 == 1 && !(a1 == 11))) return @"one";
                  if ((o.v == 0 && ((2 <= a2 && a2 <= 4)) && !((12 <= a1 && a1 <= 14)))) return @"few";
                  if ((o.v == 0 && a2 == 0) || (o.v == 0 && ((5 <= a2 && a2 <= 9))) || (o.v == 0 && ((11 <= a1 && a1 <= 14)))) return @"many";
                  return @"other";
              },
              @"ji": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"chr": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"nqo": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"bez": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"kea": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"ur": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"az": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"pa": ^(CLDRPluralOperands * o){
                  if (((o.n <= 1 && o.f == 0))) return @"one";
                  return @"other";
              },
              @"dv": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"mg": ^(CLDRPluralOperands * o){
                  if (((o.n <= 1 && o.f == 0))) return @"one";
                  return @"other";
              },
              @"smi": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  if (o.n == 2) return @"two";
                  return @"other";
              },
              @"smj": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  if (o.n == 2) return @"two";
                  return @"other";
              },
              @"lag": ^(CLDRPluralOperands * o){
                  if (((o.i <= 1) && !(o.n == 0))) return @"one";
                  if (o.n == 0) return @"zero";
                  return @"other";
              },
              @"kaj": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"kde": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"kcg": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"dz": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"gu": ^(CLDRPluralOperands * o){
                  if (o.i == 0 || o.n == 1) return @"one";
                  return @"other";
              },
              @"mk": ^(CLDRPluralOperands * o){
                  if ((o.v == 0 && fmod(o.i, 10) == 1) || fmod(o.f, 10) == 1) return @"one";
                  return @"other";
              },
              @"nso": ^(CLDRPluralOperands * o){
                  if (((o.n <= 1 && o.f == 0))) return @"one";
                  return @"other";
              },
              @"gv": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.i, 100), a2 = fmod(o.i, 10);
                  if ((o.v == 0 && a2 == 1)) return @"one";
                  if ((o.v == 0 && (a1 == 0 || a1 == 20 || a1 == 40 || a1 == 60 || a1 == 80))) return @"few";
                  if ((o.v == 0 && a2 == 2)) return @"two";
                  if (!(o.v == 0)) return @"many";
                  return @"other";
              },
              @"be": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.n, 100), a2 = fmod(o.n, 10);
                  if ((a2 == 1 && !(a1 == 11))) return @"one";
                  if ((((2 <= a2 && a2 <= 4 && o.f == 0)) && !((12 <= a1 && a1 <= 14 && o.f == 0)))) return @"few";
                  if (a2 == 0 || ((5 <= a2 && a2 <= 9 && o.f == 0)) || ((11 <= a1 && a1 <= 14 && o.f == 0))) return @"many";
                  return @"other";
              },
              @"fil": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.i, 10), a2 = fmod(o.f, 10);
                  if ((o.v == 0 && ((1 <= o.i && o.i <= 3))) || (o.v == 0 && !(a1 == 4 || a1 == 6 || a1 == 9)) || (!(o.v == 0) && !(a2 == 4 || a2 == 6 || a2 == 9))) return @"one";
                  return @"other";
              },
              @"ml": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"uz": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"mn": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"bg": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"mo": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.n, 100);
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  if (!(o.v == 0) || o.n == 0 || (!(o.n == 1) && ((1 <= a1 && a1 <= 19 && o.f == 0)))) return @"few";
                  return @"other";
              },
              @"bh": ^(CLDRPluralOperands * o){
                  if (((o.n <= 1 && o.f == 0))) return @"one";
                  return @"other";
              },
              @"se": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  if (o.n == 2) return @"two";
                  return @"other";
              },
              @"smn": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  if (o.n == 2) return @"two";
                  return @"other";
              },
              @"jbo": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"jv": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"ee": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"pl": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.i, 100), a2 = fmod(o.i, 10);
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  if ((o.v == 0 && ((2 <= a2 && a2 <= 4)) && !((12 <= a1 && a1 <= 14)))) return @"few";
                  if ((o.v == 0 && !(o.i == 1) && (a2 <= 1)) || (o.v == 0 && ((5 <= a2 && a2 <= 9))) || (o.v == 0 && ((12 <= a1 && a1 <= 14)))) return @"many";
                  return @"other";
              },
              @"sg": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"haw": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"ha": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"jw": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"mr": ^(CLDRPluralOperands * o){
                  if (o.i == 0 || o.n == 1) return @"one";
                  return @"other";
              },
              @"sh": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.f, 100), a2 = fmod(o.f, 10), a3 = fmod(o.i, 100), a4 = fmod(o.i, 10);
                  if ((o.v == 0 && a4 == 1 && !(a3 == 11)) || (a2 == 1 && !(a1 == 11))) return @"one";
                  if ((o.v == 0 && ((2 <= a4 && a4 <= 4)) && !((12 <= a3 && a3 <= 14))) || (((2 <= a2 && a2 <= 4)) && !((12 <= a1 && a1 <= 14)))) return @"few";
                  return @"other";
              },
              @"ms": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"si": ^(CLDRPluralOperands * o){
                  if (((o.n <= 1 && o.f == 0)) || (o.i == 0 && o.f == 1)) return @"one";
                  return @"other";
              },
              @"mt": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.n, 100);
                  if (o.n == 1) return @"one";
                  if (o.n == 0 || ((2 <= a1 && a1 <= 10 && o.f == 0))) return @"few";
                  if (((11 <= a1 && a1 <= 19 && o.f == 0))) return @"many";
                  return @"other";
              },
              @"bm": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"ve": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"nah": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"bn": ^(CLDRPluralOperands * o){
                  if (o.i == 0 || o.n == 1) return @"one";
                  return @"other";
              },
              @"sk": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  if ((((2 <= o.i && o.i <= 4)) && o.v == 0)) return @"few";
                  if (!(o.v == 0)) return @"many";
                  return @"other";
              },
              @"sl": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.i, 100);
                  if ((o.v == 0 && a1 == 1)) return @"one";
                  if ((o.v == 0 && ((3 <= a1 && a1 <= 4))) || !(o.v == 0)) return @"few";
                  if ((o.v == 0 && a1 == 2)) return @"two";
                  return @"other";
              },
              @"bo": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"he": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  if ((o.i == 2 && o.v == 0)) return @"two";
                  if ((o.v == 0 && !((o.n <= 10 && o.f == 0)) && fmod(o.n, 10) == 0)) return @"many";
                  return @"other";
              },
              @"ka": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"ps": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"el": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"sn": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"vi": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"my": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"br": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.n, 100), a2 = fmod(o.n, 10);
                  if ((a2 == 1 && !(a1 == 11 || a1 == 71 || a1 == 91))) return @"one";
                  if ((((3 <= a2 && a2 <= 4 && o.f == 0) || a2 == 9) && !((10 <= a1 && a1 <= 19 && o.f == 0) || (70 <= a1 && a1 <= 79 && o.f == 0) || (90 <= a1 && a1 <= 99 && o.f == 0)))) return @"few";
                  if ((a2 == 2 && !(a1 == 12 || a1 == 72 || a1 == 92))) return @"two";
                  if ((!(o.n == 0) && fmod(o.n, 1000000) == 0)) return @"many";
                  return @"other";
              },
              @"pt": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0) || (o.i == 0 && o.t == 1)) return @"one";
                  return @"other";
              },
              @"sms": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  if (o.n == 2) return @"two";
                  return @"other";
              },
              @"so": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"bs": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.f, 100), a2 = fmod(o.f, 10), a3 = fmod(o.i, 100), a4 = fmod(o.i, 10);
                  if ((o.v == 0 && a4 == 1 && !(a3 == 11)) || (a2 == 1 && !(a1 == 11))) return @"one";
                  if ((o.v == 0 && ((2 <= a4 && a4 <= 4)) && !((12 <= a3 && a3 <= 14))) || (((2 <= a2 && a2 <= 4)) && !((12 <= a1 && a1 <= 14)))) return @"few";
                  return @"other";
              },
              @"en": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"hi": ^(CLDRPluralOperands * o){
                  if (o.i == 0 || o.n == 1) return @"one";
                  return @"other";
              },
              @"sq": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"eo": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"nyn": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"jmc": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"sr": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.f, 100), a2 = fmod(o.f, 10), a3 = fmod(o.i, 100), a4 = fmod(o.i, 10);
                  if ((o.v == 0 && a4 == 1 && !(a3 == 11)) || (a2 == 1 && !(a1 == 11))) return @"one";
                  if ((o.v == 0 && ((2 <= a4 && a4 <= 4)) && !((12 <= a3 && a3 <= 14))) || (((2 <= a2 && a2 <= 4)) && !((12 <= a1 && a1 <= 14)))) return @"few";
                  return @"other";
              },
              @"ss": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"nb": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"yi": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"st": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"vo": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"es": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"nd": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"ast": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"jgo": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"sv": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"et": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"ne": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"sw": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"eu": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"kk": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"kl": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"xog": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"yo": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"hr": ^(CLDRPluralOperands * o){
                  double a1 = fmod(o.f, 100), a2 = fmod(o.f, 10), a3 = fmod(o.i, 100), a4 = fmod(o.i, 10);
                  if ((o.v == 0 && a4 == 1 && !(a3 == 11)) || (a2 == 1 && !(a1 == 11))) return @"one";
                  if ((o.v == 0 && ((2 <= a4 && a4 <= 4)) && !((12 <= a3 && a3 <= 14))) || (((2 <= a2 && a2 <= 4)) && !((12 <= a1 && a1 <= 14)))) return @"few";
                  return @"other";
              },
              @"ca": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"km": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"mas": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"rwk": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"kn": ^(CLDRPluralOperands * o){
                  if (o.i == 0 || o.n == 1) return @"one";
                  return @"other";
              },
              @"ko": ^(CLDRPluralOperands * o){
                  return @"other";
              },
              @"naq": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  if (o.n == 2) return @"two";
                  return @"other";
              },
              @"pt-PT": ^(CLDRPluralOperands * o){
                  if ((o.n == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"hu": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"ta": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
              @"nl": ^(CLDRPluralOperands * o){
                  if ((o.i == 1 && o.v == 0)) return @"one";
                  return @"other";
              },
              @"kkj": ^(CLDRPluralOperands * o){
                  if (o.n == 1) return @"one";
                  return @"other";
              },
        };
    });
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
