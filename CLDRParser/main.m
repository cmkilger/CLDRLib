//
//  main.m
//  CLDRParser
//
//  Created by Cory Kilger on 5/2/14.
//  Copyright (c) 2014 Cory Kilger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLDRPluralOperands.h"
#import "CLDRPluralRule.h"
#import "NSBundle+CLDRPlurals.h"

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
        } else if (range.location == 0) {
            [code appendFormat:@"%@ <= %@", operand, [@(NSMaxRange(range)-1) stringValue]];
        } else {
            [code appendFormat:@"(%@ <= %@ && %@ <= %@)", [@(range.location) stringValue], operand, operand, [@(NSMaxRange(range)-1) stringValue]];
        }
    }];
    
    if (self.not) {
        return [NSString stringWithFormat:@"!(%@)", code];
    } else if ([self.rangeList.values count] > 1) {
        return [NSString stringWithFormat:@"(%@)", code];
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
        [code appendString:[relation code]];
    }
    if ([self.relations count] > 1) {
        return [NSString stringWithFormat:@"(%@)", code];
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
        [code appendFormat:@"%@", [andCondition code]];
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

NSMutableString * OptimizeCode(NSMutableString * code) {
    
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"fmod\\([^\\)]+\\)" options:0 error:nil];
    
    NSMutableDictionary * counts = [[NSMutableDictionary alloc] init];
    [regex enumerateMatchesInString:code options:0 range:NSMakeRange(0, [code length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString * value = [code substringWithRange:[result range]];
        NSNumber * count = counts[value];
        if (!count) {
            count = @(0);
            counts[value] = count;
        }
        counts[value] = @([count integerValue] + 1);
    }];
    
    if ([counts count] > 0) {
        NSMutableString * variables = [[NSMutableString alloc] init];
        
        __block int n = 1;
        [counts enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj integerValue] > 1) {
                if ([variables length] > 0) {
                    [variables appendString:@", "];
                }
                NSString * variable = [[NSString alloc] initWithFormat:@"a%d", n];
                [variables appendFormat:@"%@ = %@", variable, key];
                [code replaceOccurrencesOfString:key withString:variable options:0 range:NSMakeRange(0, [code length])];
                n++;
            }
        }];
        
        if ([variables length] > 0) {
            code = [[NSMutableString alloc] initWithFormat:@"        unsigned long %@;\n%@", variables, code];
        }
    }
    
    return code;
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSData * data = [[NSData alloc] initWithContentsOfFile:@"/Users/cmkilger/Downloads/json/supplemental/plurals.json"];
        NSDictionary * input = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"supplemental"][@"plurals-type-cardinal"];
        
        NSMutableString * code = [[NSMutableString alloc] initWithString:@"rules = @{\n"];
        [input enumerateKeysAndObjectsUsingBlock:^(id language, id rules, BOOL *stop) {
            [code appendFormat:@"    @\"%@\": ^(CLDRPluralOperands o){\n", language];
            
            NSMutableString * blockCode = [[NSMutableString alloc] init];
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
                
                [blockCode appendFormat:@"        if (%@) return @\"%@\";\n", logic, [[key componentsSeparatedByString:@"-"] lastObject]];
            }];
            [blockCode appendString:@"        return @\"other\";\n"];
            
            blockCode = OptimizeCode(blockCode);
            
            [code appendString:blockCode];
            [code appendString:@"    },\n"];
        }];
        [code appendString:@"};\n"];
        
        return 0;
    }
}