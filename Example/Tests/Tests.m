//
//  Copyright (c) 2022 Alexey Nazarov. All rights reserved.
//

#import <XCTest/XCTest.h>
@import FunkObjC;
@import ModernObjC;

NS_ASSUME_NONNULL_BEGIN

@interface FunkObjC_Array_Test : XCTestCase
@end

@implementation FunkObjC_Array_Test

- (void)testEvery {
    XCTAssertTrue([(@[@0, @1, @2]) hasEvery:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue >= 0;
    }]);

    XCTAssertFalse([(@[@0, @1, @2]) hasEvery:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue > 0;
    }]);

    XCTAssertTrue([@[] hasEvery:^BOOL(id obj, NSUInteger idx) {return YES; }]);
}

- (void)testSome {
    XCTAssertTrue([(@[ @0, @1, @2 ]) hasAny:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue > 0;
    }]);

    XCTAssertFalse([(@[ @0, @1, @2 ]) hasAny:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue < 0;
    }]);

    XCTAssertFalse( [@[] hasAny:^BOOL(id obj, NSUInteger idx) { return YES; }]);
}

- (void)testFilterObject {
    XCTAssertEqualObjects([(@[ @0, @1, @2 ]) filter:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue > 1;
    }].firstObject, @2);

    XCTAssertTrue([(@[ @0, @1, @2 ]) filter:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue > 2;
    }].isEmpty);

    XCTAssertTrue([(@[]) filter:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue > 2;
    }].isEmpty);
}

- (void)testFilterObjects {
    XCTAssertEqual([[(@[ @0, @1, @2 ]) filter:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue > 1;
    }] count], 1);

    XCTAssertTrue([(@[ @0, @1, @2 ]) filter:^BOOL(NSNumber *obj, NSUInteger idx) {
        return obj.intValue > 2;
    }].isEmpty);

    XCTAssertTrue([@[] filter:^BOOL(NSNumber *obj, NSUInteger idx) { return YES; }].isEmpty);
}

- (void)testMap {
    XCTAssertEqualObjects(
       ([@[@0, @1, @2] map:^id(NSNumber *obj, NSUInteger idx) {  return obj.intValue == 1 ? [obj stringValue] : nil; }]),
       (@[NSNull.null, @"1", NSNull.null])
    );

    XCTAssertEqualObjects(
        ([@[@0, @1, @2] map:^id(id obj, NSUInteger idx) { return nil; }]),
        (@[NSNull.null, NSNull.null, NSNull.null])
    );

    XCTAssertTrue([@[] map:^id(id obj, NSUInteger idx) { return @"a"; }].isEmpty);
}

- (void)testCompactMap {
    XCTAssertEqualObjects(
       ([@[@0, @1, @2] compactMap:^id(NSNumber *obj, NSUInteger idx) { return obj.intValue == 1 ? [obj stringValue] : nil; }]),
       (@[@"1"])
    );
}

- (void)testReduce {
    XCTAssertEqualObjects(([@[ @0, @1, @2] reduce:^id(NSNumber *value, NSNumber *obj, NSUInteger idx) {
        return @( value.integerValue + obj.integerValue );
    }]), @3);

    XCTAssertEqualObjects(([@[ @0, @1, @2] reduce:^id(NSNumber *value, NSNumber *obj, NSUInteger idx) {
        return @( value.integerValue + obj.integerValue );
    } initial:@1]), @4);

    XCTAssertEqual([(@[]) reduce:^id(NSNumber *value, NSNumber *obj, NSUInteger idx) {
        return @( value.integerValue + obj.integerValue );
    }], nil);
}

- (void)testMapDict {
    XCTAssertEqualObjects(
       ([@[ @0, @1] dictionaryWithKeys:^id(id obj, NSUInteger idx) { return [[obj stringValue] stringByAppendingString:@"_"]; }]),
       (@{ @"0_": @0, @"1_": @1 })
    );

    XCTAssertEqualObjects(([@[] dictionaryWithKeys:^id(id obj, NSUInteger idx) {
        return [[obj stringValue] stringByAppendingString:@"_"];
    }]), (@{}));

    XCTAssertEqualObjects(([@[ @0, @1] dictionaryWithKeys:^id(id obj, NSUInteger idx) {
        return nil;
    }]), (@{ [NSNull null]: @0 }));
}

- (void)testIsEmpty {
    XCTAssertTrue(@[].isEmpty);
    XCTAssertFalse((@[@1, NSNull.null]).isEmpty);
}

- (void)testCompact {
    XCTAssertEqualObjects(([@[@0, @1, NSNull.null] compact]), (@[@0, @1]));
}

@end


@interface FunkObjC_Set_Test : XCTestCase
@end

@implementation FunkObjC_Set_Test

- (void)testEvery {
    XCTAssertTrue([([NSSet setWithObjects:@0, @1, @2, nil]) hasEvery:^BOOL(NSNumber *obj) {
        return obj.intValue >= 0;
    }]);

    XCTAssertFalse([([NSSet setWithObjects: @0, @1, @2, nil]) hasEvery:^BOOL(NSNumber *obj) {
        return obj.intValue > 0;
    }]);

    XCTAssertTrue( [[NSSet set] hasEvery:^BOOL(id obj) {
        return YES;
    }]);
}

- (void)testSome {
    XCTAssertTrue([([NSSet setWithObjects: @0, @1, @2, nil]) hasAny:^BOOL(NSNumber *obj) {
        return obj.intValue > 0;
    }]);

    XCTAssertFalse([([NSSet setWithObjects: @0, @1, @2, nil]) hasAny:^BOOL(NSNumber *obj) {
        return obj.intValue < 0;
    }]);

    XCTAssertFalse( [[NSSet set] hasAny:^BOOL(id obj) {
        return YES;
    }]);
}

- (void)testFilterObject {
    XCTAssertEqual([[([NSSet setWithObjects: @0, @1, @2, nil]) filter:^BOOL(NSNumber *obj) {
        return obj.intValue > 1;
    }] count], 1);

    XCTAssertTrue([([NSSet setWithObjects: @0, @1, @2, nil]) filter:^BOOL(NSNumber *obj) {
        return obj.intValue > 2;
    }].isEmpty);

    XCTAssertTrue([([NSSet set]) filter:^BOOL(NSNumber *obj) {
        return obj.intValue > 2;
    }].isEmpty);
}

- (void)testFilterObjects {
    XCTAssertEqual([[([NSSet setWithObjects: @0, @1, @2, nil]) filter:^BOOL(NSNumber *obj) {
        return obj.intValue > 1;
    }] count], 1);

    XCTAssertTrue([([NSSet setWithObjects: @0, @1, @2, nil ]) filter:^BOOL(NSNumber *obj) {
        return obj.intValue > 2;
    }].isEmpty);

    XCTAssertTrue([[NSSet set] filter:^BOOL(NSNumber *obj) { return YES; }].isEmpty);
}

- (void)testMap {
    let set = (NSSet<NSNumber *> *)[NSSet setWithObjects: @0, @1, @2, nil];
    XCTAssertEqualObjects(
        ([set map:^id(NSNumber *obj) { return obj.intValue == 1 ? [obj stringValue] : nil; }]),
        ([NSSet setWithObjects: NSNull.null, @"1", NSNull.null, nil])
    );

    XCTAssertEqualObjects(
       ([set map:^id(id obj) { return nil; }]),
       ([NSSet setWithObjects: [NSNull null], [NSNull null], [NSNull null], nil])
    );

    XCTAssertTrue(([NSSet.set map:^id(id obj) { return @"a"; }]).isEmpty);
}

- (void)testCompactMap {
    let set = (NSSet<NSNumber *> *)[NSSet setWithObjects: @0, @1, @2, nil];
    XCTAssertEqualObjects(
        ([set compactMap:^id(NSNumber *obj) { return obj.intValue == 1 ? [obj stringValue] : nil; }]),
        ([NSSet setWithObjects: @"1", nil])
    );
}

- (void)testReduce {
    XCTAssertEqual([[([NSSet setWithObjects: @0, @1, @2 , nil]) reduce:^id(NSNumber *value, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    }] integerValue], 3);

    XCTAssertEqual([[([NSSet setWithObjects: @0, @1, @2, nil ]) reduce:^id(NSNumber *value, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    } initial:@1] integerValue], 4);

    XCTAssertEqual([([NSSet set]) reduce:^id(NSNumber *value, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    }], nil);
}

- (void)testIsEmpty {
    XCTAssertTrue(NSSet.set.isEmpty);
    XCTAssertFalse(([NSSet setWithObjects: @0, @1, @2, nil]).isEmpty);
}

- (void)testCompact {
    XCTAssertEqualObjects(([[NSSet setWithObjects: @0, @1, NSNull.null, nil] compact]), ([NSSet setWithObjects: @0, @1, nil]));
}

@end


@interface FunkObjC_Dictionary_Test : XCTestCase
@end

@implementation FunkObjC_Dictionary_Test

- (void)testEvery {
    XCTAssertTrue([(@{@0: @0, @1: @1, @2: @2}) hasEvery:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue >= 0;
    }]);

    XCTAssertFalse([(@{@0: @0, @1: @1, @2: @2}) hasEvery:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue > 0;
    }]);

    XCTAssertTrue( [@{} hasEvery:^BOOL(id key, id obj) {
        return YES;
    }]);
}

- (void)testSome {
    XCTAssertTrue([(@{@0: @0, @1: @1, @2: @2}) hasAny:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue > 0;
    }]);

    XCTAssertFalse([(@{@0: @0, @1: @1, @2: @2}) hasAny:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue < 0;
    }]);

    XCTAssertFalse( [@{} hasAny:^BOOL(id key, id obj) {
        return YES;
    }]);
}

- (void)testFilterObject {
    XCTAssertEqual([[(@{@0: @0, @1: @1, @2: @2}) filter:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue > 1;
    }] count], 1);

    XCTAssertEqualObjects([(@{@0: @0, @1: @1, @2: @2}) filter:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue > 2;
    }], (@{}));

    XCTAssertEqualObjects([(@{@0: @0, @1: @10, @2: @2}) filter:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue > 2;
    }], (@{@1: @10}));

    XCTAssertEqualObjects([(@{}) filter:^BOOL(NSNumber *key, NSNumber *obj) {
        return obj.intValue > 2;
    }], (@{}));
}

- (void)testMap {
    XCTAssertEqualObjects(([(@{@0: @0, @1: @1, @2: @2}) mapObjects:^id(id key, id obj) {
        return [obj stringValue];
    }]), (@{@0:@"0", @1:@"1", @2:@"2"}));

    XCTAssertEqualObjects(([(@{@0:@0, @1:@1, @2:@2}) mapObjects:^id(id key, id obj) {
        return nil;
    }]), (@{@0:NSNull.null, @1:NSNull.null, @2:NSNull.null}));

    XCTAssertTrue([@{} mapObjects:^id(id key, id obj) { return @"a"; }].isEmpty);


    XCTAssert([[(@{@0: @0, @1: @1, @2: @2}) mapKeys:^id(id key, id obj) {
        return [obj stringValue];
    }] isEqualToDictionary:(@{@"0": @0, @"1":@1, @"2":@2})]);

    XCTAssertEqual([(@{@0:@0, @1:@1, @2:@2}) mapKeys:^id(id key, id obj) {
        return nil;
    }].count, 1);

    XCTAssertTrue([@{} mapKeys:^id(id key, id obj) { return @"a"; }].isEmpty);
}

- (void)testReduce {
    XCTAssertEqual([[(@{@0: @0, @1: @1, @2: @2 }) reduce:^id(NSNumber *value, NSNumber *key, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    }] integerValue], 3);

    XCTAssertEqual([[(@{@0: @0, @1: @1, @2: @2}) reduce:^id(NSNumber *value, NSNumber *key, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    } initial:@1] integerValue], 4);

    XCTAssertEqual([(@{}) reduce:^id(NSNumber *key, NSNumber *value, NSNumber *obj) {
        return @( value.integerValue + obj.integerValue );
    }], nil);
}

- (void)testIsEmpty {
    XCTAssertTrue(@{}.isEmpty);
    XCTAssertFalse(@{@1: NSNull.null}.isEmpty);
}

- (void)testCompact {
    XCTAssertEqualObjects(([(@{@0:@0, @1:@1, @2:NSNull.null}) compact]), (@{@0:@0, @1:@1}));
}

- (void)testFirst {
    XCTAssertEqualObjects(([(@{@0: @0, @1: @1, @2: @20 }) first:^BOOL(NSNumber *key, NSNumber *obj) {
        return key.intValue == 2;
    }]), (@20));
}

@end

@interface FunkObjC_Test : XCTestCase
@end

@implementation FunkObjC_Test

- (void)testComparator {
    XCTAssertEqualObjects(([@[@100, @0, @2] sortedArrayUsingComparator:FOBlockComparator(^BOOL(NSNumber  *a, NSNumber *b) {
        return a.intValue < b.intValue;
    })]), (@[@0, @2, @100]));
}

@end

NS_ASSUME_NONNULL_END
