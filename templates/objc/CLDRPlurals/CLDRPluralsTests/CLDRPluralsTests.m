//
//  CLDRPluralsTests.m
//  CLDRPluralsTests
//
//  Created by Cory Kilger on 5/5/14.
//  Copyright (c) 2014 Cory Kilger. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CLDRPlurals/CLDRPlurals.h>

@interface CLDRPluralsTests : XCTestCase

@end

@implementation CLDRPluralsTests

- (void)testOperandWithCount {
    CLDRPluralOperands * o = [[CLDRPluralOperands alloc] initWithCount:5];
    XCTAssert(o.n == 5, @"");
    XCTAssert(o.i == 5, @"");
    XCTAssert(o.v == 0, @"");
    XCTAssert(o.w == 0, @"");
    XCTAssert(o.f == 0, @"");
    XCTAssert(o.t == 0, @"");
}

- (void)testOperandWithAmount {
    CLDRPluralOperands * o = [[CLDRPluralOperands alloc] initWithAmount:1.230];
    XCTAssert(o.n == 1.23, @"");
    XCTAssert(o.i == 1, @"");
    XCTAssert(o.v == 2, @"");
    XCTAssert(o.w == 2, @"");
    XCTAssert(o.f == 23, @"");
    XCTAssert(o.t == 23, @"");
}

- (void)testOperandWithString {
    CLDRPluralOperands * o = [[CLDRPluralOperands alloc] initWithString:@"1.230"];
    XCTAssert(o.n == 1.23, @"");
    XCTAssert(o.i == 1, @"");
    XCTAssert(o.v == 3, @"");
    XCTAssert(o.w == 2, @"");
    XCTAssert(o.f == 230, @"");
    XCTAssert(o.t == 23, @"");
}

- (void)testOperandWithStringAndOptions {
    CLDRPluralOperands * o = [[CLDRPluralOperands alloc] initWithString:@"1,230" options:@{CLDRPluralRuleOptionDecimalSeparator: @","}];
    XCTAssert(o.n == 1.23, @"");
    XCTAssert(o.i == 1, @"");
    XCTAssert(o.v == 3, @"");
    XCTAssert(o.w == 2, @"");
    XCTAssert(o.f == 230, @"");
    XCTAssert(o.t == 23, @"");
}

- (void)testOperandIsEqual {
    CLDRPluralOperands * o1 = [[CLDRPluralOperands alloc] initWithString:@"1,230" options:@{CLDRPluralRuleOptionDecimalSeparator: @","}];
    CLDRPluralOperands * o2 = [[CLDRPluralOperands alloc] init];
    o2.n = 1.23;
    o2.i = 1;
    o2.v = 3;
    o2.w = 2;
    o2.f = 230;
    o2.t = 23;
    
    XCTAssertEqualObjects(o1, o2, @"");
}

- (void)testOperandHashIsEqual {
    CLDRPluralOperands * o1 = [[CLDRPluralOperands alloc] initWithString:@"1,230" options:@{CLDRPluralRuleOptionDecimalSeparator: @","}];
    CLDRPluralOperands * o2 = [[CLDRPluralOperands alloc] init];
    o2.n = 1.23;
    o2.i = 1;
    o2.v = 3;
    o2.w = 2;
    o2.f = 230;
    o2.t = 23;
    
    XCTAssert(o1.hash == o2.hash, @"");
}

#define LocalizedStringWithCount(key, input) \
    ([NSString stringWithFormat:[bundle pluralLocalizedStringForKey:key count:input value:nil table:nil], @(input)])
#define LocalizedStringWithAmount(key, input) \
    ([NSString stringWithFormat:[bundle pluralLocalizedStringForKey:key amount:input value:nil table:nil], @(input)])
#define LocalizedStringWithString(key, input) \
    ([NSString stringWithFormat:[bundle pluralLocalizedStringForKey:key pluralValue:input options:@{CLDRPluralRuleOptionDecimalSeparator: @","} value:nil table:nil], input])

- (void)testLocalizedStrings {
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    XCTAssertEqualObjects(LocalizedStringWithCount(@"cats", 1), @"1 cat", @"");
    XCTAssertEqualObjects(LocalizedStringWithCount(@"cats", 2), @"2 cats", @"");
    XCTAssertEqualObjects(LocalizedStringWithAmount(@"miles", 1.0), @"1 mile", @"");
    XCTAssertEqualObjects(LocalizedStringWithAmount(@"miles", 1.20), @"1.2 miles", @"");
    XCTAssertEqualObjects(LocalizedStringWithString(@"pounds", @"1"), @"1 pound", @"");
    XCTAssertEqualObjects(LocalizedStringWithString(@"pounds", @"1,000"), @"1,000 pounds", @"");
    XCTAssertEqualObjects(LocalizedStringWithString(@"pounds", @"1,230"), @"1,230 pounds", @"");
}

@end
