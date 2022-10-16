//
//  Copyright (c) 2022 Alexey Nazarov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FuncObjC/FuncObjC.h>

@interface FuncObjC_Array_Test : XCTestCase
@end

@implementation FuncObjC_Array_Test

- (void)testEvery {
    XCTAssert([(@[ @0, @1, @2 ]) everyObject:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue >= 0;
    }]);

    XCTAssert(![(@[ @0, @1, @2 ]) everyObject:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue > 0;
    }]);

    XCTAssert( [@[ @1 ] everyObject:nil] == YES );
    XCTAssert( [@[] everyObject:^BOOL(id obj, NSUInteger idx) {
        return YES;
    }] == YES );
}

- (void)testSome {
    XCTAssert([(@[ @0, @1, @2 ]) someObject:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue > 0;
    }]);

    XCTAssert(![(@[ @0, @1, @2 ]) someObject:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue < 0;
    }]);

    XCTAssert( [@[ @1 ] someObject:nil] == NO );
    XCTAssert( [@[] someObject:^BOOL(id obj, NSUInteger idx) {
        return YES;
    }] == NO );
}

- (void)testFilterObject {
    XCTAssert([[(@[ @0, @1, @2 ]) filterObject:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        return obj.intValue > 1;
    }] intValue] == 2);

    XCTAssert([(@[ @0, @1, @2 ]) filterObject:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        return obj.intValue > 2;
    }] == nil);

    XCTAssert([(@[]) filterObject:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        return obj.intValue > 2;
    }] == nil);
    XCTAssert([@[@1] filterObject:nil] == nil);
}

- (void)testFilterObjects {
    XCTAssert([[(@[ @0, @1, @2 ]) filterObjects:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        return obj.intValue > 1;
    }] count] == 1);

    XCTAssert([(@[ @0, @1, @2 ]) filterObjects:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        return obj.intValue > 2;
    }].count == 0);

    XCTAssert([@[@1] filterObjects:nil] == nil);
    XCTAssert([@[] filterObjects:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) { return YES; }].count == 0);
}

- (void)testMap {
    XCTAssert([[(@[ @0, @1, @2 ]) mapObjects:^id(id obj, NSUInteger idx) {
        return [obj stringValue];
    }] isEqualToArray:(@[ @"0", @"1", @"2" ])]);

    XCTAssert([[(@[ @0, @1, @2 ]) mapObjects:^id(id obj, NSUInteger idx) {
        return nil;
    }] isEqualToArray:(@[ [NSNull null], [NSNull null], [NSNull null] ])]);

    XCTAssert([[@[@1] mapObjects:nil] isEqualToArray:@[ @1 ]]);
    XCTAssert([@[] mapObjects:^id(id obj, NSUInteger idx) { return @"a"; }].count == 0);
}

- (void)testReduce {
    XCTAssert([[(@[ @0, @1, @2 ]) reduceObjects:^id(NSNumber *value, NSNumber *obj, NSUInteger idx) {
        return @( value.integerValue + obj.integerValue );
    }] integerValue] == 3);

    XCTAssert([[(@[ @0, @1, @2 ]) reduceObjects:^id(NSNumber *value, NSNumber *obj, NSUInteger idx) {
        return @( value.integerValue + obj.integerValue );
    } initial:@1] integerValue] == 4);

    XCTAssert([(@[ @0, @1]) reduceObjects:nil] == nil);
    XCTAssert([(@[]) reduceObjects:^id(NSNumber *value, NSNumber *obj, NSUInteger idx) {
        return @( value.integerValue + obj.integerValue );
    }] == nil);
}

- (void)testMapDict {
    XCTAssert([[(@[ @0, @1]) dictionaryWithMappedKeys:^id(id obj, NSUInteger idx) {
        return [[obj stringValue] stringByAppendingString:@"_"];
    }] isEqualToDictionary:(@{ @"0_": @0, @"1_": @1 })]);

    XCTAssert([[(@[ @0 ]) dictionaryWithMappedKeys:nil] isEqualToDictionary:(@{ @0: @0})]);
    XCTAssert([[(@[]) dictionaryWithMappedKeys:^id(id obj, NSUInteger idx) {
        return [[obj stringValue] stringByAppendingString:@"_"];
    }] isEqualToDictionary:(@{})]);

    XCTAssert([[(@[ @0, @1]) dictionaryWithMappedKeys:^id(id obj, NSUInteger idx) {
        return nil;
    }] isEqualToDictionary:(@{ [NSNull null]: @0 })]);
}

@end


@interface FuncObjC_Set_Test : XCTestCase
@end

@implementation FuncObjC_Set_Test

- (void)testEvery {
    XCTAssert([([NSSet setWithObjects:@0, @1, @2, nil]) everyObject:^BOOL(NSNumber *obj) {
        return obj.intValue >= 0;
    }]);

    XCTAssert(![([NSSet setWithObjects: @0, @1, @2, nil]) everyObject:^BOOL(NSNumber *obj) {
        return obj.intValue > 0;
    }]);

    XCTAssert( [([NSSet setWithObjects: @1, nil]) everyObject:nil] == YES );
    XCTAssert( [[NSSet set] everyObject:^BOOL(id obj) {
        return YES;
    }] == YES );
}

- (void)testSome {
    XCTAssert([([NSSet setWithObjects: @0, @1, @2, nil]) someObject:^BOOL(NSNumber *obj) {
        return obj.intValue > 0;
    }]);

    XCTAssert(![([NSSet setWithObjects: @0, @1, @2, nil]) someObject:^BOOL(NSNumber *obj) {
        return obj.intValue < 0;
    }]);

    XCTAssert( [([NSSet setWithObjects: @1, nil]) someObject:nil] == NO );
    XCTAssert( [[NSSet set] someObject:^BOOL(id obj) {
        return YES;
    }] == NO );
}

- (void)testFilterObject {
    XCTAssert([[([NSSet setWithObjects: @0, @1, @2, nil]) filterObject:^BOOL(NSNumber *obj, BOOL *stop) {
        return obj.intValue > 1;
    }] intValue] == 2);

    XCTAssert([([NSSet setWithObjects: @0, @1, @2, nil]) filterObject:^BOOL(NSNumber *obj, BOOL *stop) {
        return obj.intValue > 2;
    }] == nil);

    XCTAssert([([NSSet set]) filterObject:^BOOL(NSNumber *obj, BOOL *stop) {
        return obj.intValue > 2;
    }] == nil);

    XCTAssert([([NSSet setWithObjects:@1, nil]) filterObject:nil] == nil);
}

- (void)testFilterObjects {
    XCTAssert([[([NSSet setWithObjects: @0, @1, @2, nil]) filterObjects:^BOOL(NSNumber *obj, BOOL *stop) {
        return obj.intValue > 1;
    }] count] == 1);

    XCTAssert([([NSSet setWithObjects: @0, @1, @2, nil ]) filterObjects:^BOOL(NSNumber *obj, BOOL *stop) {
        return obj.intValue > 2;
    }].count == 0);

    XCTAssert([([NSSet setWithObjects:@1, nil]) filterObjects:nil] == nil);
    XCTAssert([[NSSet set] filterObjects:^BOOL(NSNumber *obj, BOOL *stop) { return YES; }].count == 0);
}

- (void)testMap {
    XCTAssert([[([NSSet setWithObjects: @0, @1, @2, nil ]) mapObjects:^id(id obj) {
        return [obj stringValue];
    }] isEqualToSet:([NSSet setWithObjects: @"0", @"1", @"2", nil])]);

    XCTAssert([[([NSSet setWithObjects: @0, @1, @2, nil]) mapObjects:^id(id obj) {
        return nil;
    }] isEqualToSet:([NSSet setWithObjects: [NSNull null], [NSNull null], [NSNull null], nil])]);

    XCTAssert([[([NSSet setWithObjects:@1, nil]) mapObjects:nil] isEqualToSet:([NSSet setWithObjects: @1, nil])]);
    XCTAssert([[NSSet set] mapObjects:^id(id obj) { return @"a"; }].count == 0);
}

- (void)testReduce {
    XCTAssert([[([NSSet setWithObjects: @0, @1, @2 , nil]) reduceObjects:^id(NSNumber *value, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    }] integerValue] == 3);

    XCTAssert([[([NSSet setWithObjects: @0, @1, @2, nil ]) reduceObjects:^id(NSNumber *value, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    } initial:@1] integerValue] == 4);

    XCTAssert([([NSSet setWithObjects: @0, @1, nil]) reduceObjects:nil] == nil);
    XCTAssert([([NSSet set]) reduceObjects:^id(NSNumber *value, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    }] == nil);
}

@end


@interface FuncObjC_Dictionary_Test : XCTestCase
@end

@implementation FuncObjC_Dictionary_Test

- (void)testEvery {
    XCTAssert([(@{@0: @0, @1: @1, @2: @2}) everyObject:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue >= 0;
    }]);

    XCTAssert(![(@{@0: @0, @1: @1, @2: @2}) everyObject:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue > 0;
    }]);

    XCTAssert( [(@{@1: @1}) everyObject:nil] == YES );
    XCTAssert( [@{} everyObject:^BOOL(id key, id obj) {
        return YES;
    }] == YES );
}

- (void)testSome {
    XCTAssert([(@{@0: @0, @1: @1, @2: @2}) someObject:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue > 0;
    }]);

    XCTAssert(![(@{@0: @0, @1: @1, @2: @2}) someObject:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue < 0;
    }]);

    XCTAssert( [(@{@1: @1}) someObject:nil] == NO );
    XCTAssert( [@{} someObject:^BOOL(id key, id obj) {
        return YES;
    }] == NO );
}

- (void)testFilterObject {
    XCTAssert([[(@{@0: @0, @1: @1, @2: @2}) filterObject:^BOOL(NSNumber *key, NSNumber *obj, BOOL *stop) {
        return obj.intValue > 1;
    }] intValue] == 2);

    XCTAssert([(@{@0: @0, @1: @1, @2: @2}) filterObject:^BOOL(NSNumber *key, NSNumber *obj, BOOL *stop) {
        return obj.intValue > 2;
    }] == nil);

    XCTAssert([(@{}) filterObject:^BOOL(NSNumber *key, NSNumber *obj, BOOL *stop) {
        return obj.intValue > 2;
    }] == nil);

    XCTAssert([(@{@1: @1}) filterObject:nil] == nil);
}

- (void)testFilterObjects {
    XCTAssert([[(@{@0: @0, @1: @1, @2: @2}) filterObjects:^BOOL(NSNumber *key, NSNumber *obj, BOOL *stop) {
        return obj.intValue > 1;
    }] count] == 1);

    XCTAssert([(@{@0: @0, @1: @1, @2: @2}) filterObjects:^BOOL(NSNumber *key, NSNumber *obj, BOOL *stop) {
        return obj.intValue > 2;
    }].count == 0);

    XCTAssert([(@{@1: @1}) filterObjects:nil] == nil);
    XCTAssert([@{} filterObjects:^BOOL(NSNumber *key, NSNumber *obj, BOOL *stop) { return YES; }].count == 0);
}

- (void)testMap {
    XCTAssert([[(@{@0: @0, @1: @1, @2: @2}) mapObjects:^id(id key, id obj) {
        return [obj stringValue];
    }] isEqualToDictionary:(@{@0:@"0", @1:@"1", @2:@"2"})]);

    XCTAssert([[(@{@0:@0, @1:@1, @2:@2}) mapObjects:^id(id key, id obj) {
        return nil;
    }] isEqualToDictionary:(@{@0:[NSNull null], @1:[NSNull null], @2:[NSNull null]})]);

    XCTAssert([[(@{@1:@1}) mapObjects:nil] isEqualToDictionary:(@{@1:@1})]);
    XCTAssert([@{} mapObjects:^id(id key, id obj) { return @"a"; }].count == 0);


    XCTAssert([[(@{@0: @0, @1: @1, @2: @2}) mapKeys:^id(id key, id obj) {
        return [obj stringValue];
    }] isEqualToDictionary:(@{@"0": @0, @"1":@1, @"2":@2})]);

    XCTAssert([(@{@0:@0, @1:@1, @2:@2}) mapKeys:^id(id key, id obj) {
        return nil;
    }].count == 1 );

    XCTAssert([[(@{@1:@1}) mapKeys:nil] isEqualToDictionary:(@{@1:@1})]);
    XCTAssert([@{} mapKeys:^id(id key, id obj) { return @"a"; }].count == 0);
}

- (void)testReduce {
    XCTAssert([[(@{@0: @0, @1: @1, @2: @2 }) reduceObjects:^id(NSNumber *value, NSNumber *key, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    }] integerValue] == 3);

    XCTAssert([[(@{@0: @0, @1: @1, @2: @2}) reduceObjects:^id(NSNumber *value, NSNumber *key, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    } initial:@1] integerValue] == 4);

    XCTAssert([(@{@0: @0, @1: @1}) reduceObjects:nil] == nil);
    XCTAssert([(@{}) reduceObjects:^id(NSNumber *key, NSNumber *value, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    }] == nil);
}

@end
