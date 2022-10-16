//
// Copyright (c) Alex Nazarov, 2021
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

@import Foundation;
@import ModernObjC;

// #define FCT_USE_PREFIX

#if defined(FCT_USE_PREFIX)
    #if !defined(FCT_PREFIX)
        #define FCT_PREFIX(M) fn_##M
    #endif
#else
    #define FCT_PREFIX(M) M
#endif

//
// Filter, Map, Reduce
//
NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ItemType> (FunkObjC)

- (BOOL)FCT_PREFIX(hasEvery):(BOOL (^)(ItemType item, NSUInteger idx))predicate WARN_UNUSED_RESULT;
- (BOOL)FCT_PREFIX(hasAny):(BOOL (^)(ItemType item, NSUInteger idx))predicate WARN_UNUSED_RESULT;

- (ItemType _Nullable)FCT_PREFIX(first):(BOOL (^)(ItemType item, NSUInteger idx))predicate WARN_UNUSED_RESULT;
- (NSArray<ItemType> *)FCT_PREFIX(filter):(BOOL (^)(ItemType item, NSUInteger idx))predicate WARN_UNUSED_RESULT;

/// Returns an array containing the results of mapping the given closure
/// over the sequence's elements.
///
/// In this example, `map` is used first to convert the names in the array
/// to lowercase strings and then to count their characters.
///
///     let cast = @[@"Vivien", @"Marlon", @"Kim", @"Karl"];
///     let lowercaseNames = [cast map:^(NSString *item, NSUInteger idx){ return item.lowercased }];
///     // 'lowercaseNames' == @[@"vivien", @"marlon", @"kim", @"karl"];
///     let letterCounts = [cast map:^(NSString *item, NSUInteger idx){ return item.length }];
///     // 'letterCounts' == [6, 6, 3, 4]
///
/// - Parameter transform: A mapping closure. `transform` accepts an
///   element of this sequence as its parameter and returns a transformed
///   value of the same or of a different type.
/// - Returns: An array containing the transformed elements of this
///   sequence.
- (NSArray *)FCT_PREFIX(map):(id (^)(ItemType item, NSUInteger idx))transform WARN_UNUSED_RESULT;
- (NSArray *)FCT_PREFIX(compactMap):(id (^)(ItemType item, NSUInteger idx))transform WARN_UNUSED_RESULT;
- (NSArray<ItemType> *)FCT_PREFIX(compact) WARN_UNUSED_RESULT;

- (id _Nullable)FCT_PREFIX(reduce):(ItemType _Nullable (^)(ItemType _Nullable value, ItemType next, NSUInteger idx))transform;
- (id _Nullable)FCT_PREFIX(reduce):(ItemType _Nullable (^)(ItemType _Nullable value, ItemType next, NSUInteger idx))transform initial:(ItemType _Nullable)initial;

- (NSDictionary<id, ItemType> *)FCT_PREFIX(dictionaryWithKeys):(id (^)(ItemType value, NSUInteger idx))transform WARN_UNUSED_RESULT;

@property (nonatomic, assign, readonly) BOOL FCT_PREFIX(isEmpty);

@end

@interface NSSet<__covariant ItemType> (FunkObjC)

- (BOOL)FCT_PREFIX(hasEvery):(BOOL (^)(ItemType item))predicate WARN_UNUSED_RESULT;
- (BOOL)FCT_PREFIX(hasAny):(BOOL (^)(ItemType item))predicate WARN_UNUSED_RESULT;

- (ItemType _Nullable)FCT_PREFIX(first):(BOOL (^)(ItemType item))predicate WARN_UNUSED_RESULT;
- (NSArray<ItemType> *)FCT_PREFIX(filter):(BOOL (^)(ItemType item))predicate WARN_UNUSED_RESULT;

- (NSArray *)FCT_PREFIX(map):(id (^)(ItemType item))transform WARN_UNUSED_RESULT;
- (NSArray *)FCT_PREFIX(compactMap):(id (^)(ItemType item))transform WARN_UNUSED_RESULT;
- (NSArray<ItemType> *)FCT_PREFIX(compact) WARN_UNUSED_RESULT;

- (id _Nullable)FCT_PREFIX(reduce):(ItemType _Nullable (^)(ItemType _Nullable value, ItemType next))transform;
- (id _Nullable)FCT_PREFIX(reduce):(ItemType _Nullable (^)(ItemType _Nullable value, ItemType next))transform initial:(ItemType _Nullable)initial;

@property (nonatomic, assign, readonly) BOOL FCT_PREFIX(isEmpty);

@end

@interface NSDictionary<__covariant KeyType, __covariant ValueType> (FunkObjC)

- (BOOL)FCT_PREFIX(hasEvery):(BOOL (^)(KeyType key, ValueType obj))predicate WARN_UNUSED_RESULT;
- (BOOL)FCT_PREFIX(hasAny):(BOOL (^)(KeyType key, ValueType obj))predicate WARN_UNUSED_RESULT;

- (ValueType)FCT_PREFIX(first):(BOOL (^)(KeyType key, ValueType obj))predicate WARN_UNUSED_RESULT;
- (NSDictionary<KeyType, ValueType> *)FCT_PREFIX(filter):(BOOL (^)(KeyType key, ValueType obj))predicate WARN_UNUSED_RESULT;

- (NSDictionary<KeyType, id> *)FCT_PREFIX(mapObjects):(id (^)(KeyType key, ValueType obj))transform WARN_UNUSED_RESULT;
- (NSDictionary<id, ValueType> *)FCT_PREFIX(mapKeys):(id (^)(KeyType key, ValueType obj))transform WARN_UNUSED_RESULT;
- (NSDictionary<KeyType, ValueType> *)FCT_PREFIX(compact) WARN_UNUSED_RESULT;

- (id _Nullable)FCT_PREFIX(reduce):(id _Nullable (^)(id _Nullable value, KeyType key, ValueType obj))transform;
- (id _Nullable)FCT_PREFIX(reduce):(id _Nullable (^)(id _Nullable value, KeyType key, ValueType obj))transform initial:(id _Nullable)initial;

@property (nonatomic, assign, readonly) BOOL FCT_PREFIX(isEmpty);

@end

extern NSComparator FOBlockComparator(BOOL (^less)(id a, id b));

NS_ASSUME_NONNULL_END
