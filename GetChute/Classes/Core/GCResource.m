//
//  ChuteResource.m
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "GCResource.h"
#import "GCResponseObject.h"

@interface GCResource()

+ (NSString *)elementName;

- (id) initWithDictionary:(NSDictionary *) dictionary;

@end

@implementation GCResource

#pragma mark - All 
/* Get all Objects of this class */
+ (GCResponseObject *)all {
    NSString *_path                 = [[NSString alloc] initWithFormat:@"%@/me/%@", API_URL, [self elementName]];
    GCRest *gcRest                  = [[GCRest alloc] init];
    GCResponseObject *_response     = [[gcRest getRequestWithPath:_path] retain];
    
    NSMutableArray *_result = [[NSMutableArray alloc] init];
    for (NSDictionary *_dic in [_response object]) {
        id _obj = [[[self alloc] initWithDictionary:_dic] autorelease];
        [_result addObject:_obj];
    }
    [_response setData:_result];
    [_result release];
    [gcRest release];
    [_path release];
    return [_response autorelease]; 
}

+ (void)allInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock {      
    DO_IN_BACKGROUND([self all], aResponseBlock);
}

+ (GCResponseObject *)findById:(NSUInteger) objectID {
    NSString *_path     = [[NSString alloc] initWithFormat:@"%@%@/%d", API_URL, [self elementName], objectID];
    GCRest *gcRest      = [[GCRest alloc] init];

    GCResponseObject *_response        = [[gcRest getRequestWithPath:_path] retain];
    [_response setData:[[self alloc] initWithDictionary:[_response object]]];
    
    [gcRest release];
    [_path release];
    return [_response autorelease];
}

+ (void)findById:(NSUInteger) objectID inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock {
    DO_IN_BACKGROUND([self findById:objectID], aResponseBlock);
}

#pragma mark - Override these methods in every Subclass
+ (NSString *)elementName {
    //for example, this should return the string "chutes", "assets", "bundles", "parcels"
    return nil;
}

+ (BOOL)supportsMetaData {
    return YES;
}

#pragma mark - Instance Methods
#pragma mark - Init

- (id) init {
    self = [super init];
    if (self) {
        _content = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *) dictionary {
    [self init];
    for (NSString *key in [dictionary allKeys]) {
        [self setObject:[dictionary objectForKey:key] forKey:key];
    }
    return self;
}

- (void) dealloc {
    [_content release];
    [super dealloc];
}

- (void)setObject:(id) aObject forKey:(id)aKey {
    [_content setObject:aObject forKey:aKey];
}

- (id)objectForKey:(id)aKey {
    return [_content objectForKey:aKey];
}

#pragma mark - Proxy for JSONRepresentation
- (id)proxyForJson {
    return _content;
}

#pragma mark - Common Meta Data Methods

- (GCResponseObject *) getMetaData {
    NSString *_path     = [[NSString alloc] initWithFormat:@"%@%@/%d/meta", API_URL, [[self class] elementName], [self objectID]];
    GCRest *gcRest                     = [[GCRest alloc] init];
    GCResponseObject *_response        = [[gcRest getRequestWithPath:_path] retain];
    [gcRest release];
    [_path release];
    return [_response autorelease];
}

- (void) getMetaDataInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock {
    DO_IN_BACKGROUND([self getMetaData], aResponseBlock);
}

- (GCResponseObject *) getMetaDataForKey:(NSString *) key {
    NSString *_path     = [[NSString alloc] initWithFormat:@"%@%@/%d/meta/%@", API_URL, [[self class] elementName], [self objectID], key];
    
    GCRest *gcRest                      = [[GCRest alloc] init];
    GCResponseObject *_response         = [[gcRest getRequestWithPath:_path] retain];
    [gcRest release];
    [_path release];
    return [_response autorelease];
}

- (BOOL) setMetaData:(NSDictionary *) metaData {
    NSMutableDictionary *_params = [[NSMutableDictionary alloc] init];
    [_params setValue:[[metaData JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"raw"];

    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/%d/meta", API_URL, [[self class] elementName], [self objectID]];
    
    GCRest *gcRest              = [[GCRest alloc] init];
    BOOL _response              = [[gcRest postRequestWithPath:_path andParams:_params] isSuccessful];
    [gcRest release];
    [_path release];
    [_params release];
    return _response;
}

- (BOOL) setMetaData:(NSString *) data forKey:(NSString *) key {
    NSMutableDictionary *_params = [[NSMutableDictionary alloc] init];
    [_params setValue:[data dataUsingEncoding:NSUTF8StringEncoding] forKey:@"raw"];
    
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/%d/meta/%@", API_URL, [[self class] elementName], [self objectID], key];
    
    GCRest *gcRest              = [[GCRest alloc] init];
    BOOL _response              = [[gcRest postRequestWithPath:_path andParams:_params] isSuccessful];
    [gcRest release];
    [_path release];
    [_params release];
    return _response;
}

- (BOOL) deleteMetaData {
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/%d/meta", API_URL, [[self class] elementName], [self objectID]];
    
    GCRest *gcRest              = [[GCRest alloc] init];
    BOOL _response              = [[gcRest deleteRequestWithPath:_path andParams:nil] isSuccessful];
    [gcRest release];
    [_path release];
    return _response;
}

- (BOOL) deleteMetaDataForKey:(NSString *) key {
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/%d/meta/%@", API_URL, [[self class] elementName], [self objectID], key];
    
    GCRest *gcRest              = [[GCRest alloc] init];
    BOOL _response              = [[gcRest deleteRequestWithPath:_path andParams:nil] isSuccessful];
    [gcRest release];
    [_path release];
    return _response;
}

- (NSUInteger) objectID {
    return [[_content objectForKey:@"id"] intValue];
}

#pragma mark - Instance Method Calls

- (BOOL) save {
    DLog(@"%@", [self JSONRepresentation]);
    return NO;
}

- (void) saveInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock {
    
}

- (BOOL) destroy {
    NSString *_path     = [[NSString alloc] initWithFormat:@"%@%@/%d", API_URL, [[self class] elementName], [self objectID]];
    
    GCRest *gcRest      = [[GCRest alloc] init];
    BOOL _response      = [[gcRest deleteRequestWithPath:_path andParams:nil] isSuccessful];
    [gcRest release];
    [_path release];
    return _response;
}

- (void) destroyInBackgroundWithCompletion:(GCBoolBlock) aResponseBlock {
    DO_IN_BACKGROUND_BOOL([self destroy], aResponseBlock);
}

@end