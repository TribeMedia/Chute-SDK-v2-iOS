//
//  GCObject.m
//
//  Created by Achal Aggarwal on 05/09/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "GCResponse.h"

@implementation GCResponse

@synthesize object;
@synthesize error;
@synthesize rawResponse;
@synthesize data;

- (BOOL) isSuccessful {
    if (IS_NULL([self error])) {
        return YES;
    }
    DLog(@"%@", [[self error] localizedDescription]);
    return NO;
}

- (id) object {
    return [object objectForKey:@"data"];
}

- (id) objectForKey:(id)key {
    if ([[self object] class] == [NSDictionary class]) {
        return [[self object] objectForKey:key];
    }
    return nil;
}

- (id) valueForKey:(NSString *)key {
    if ([[self object] class] == [NSDictionary class]) {
        return [[self object] valueForKey:key];
    }
    return nil;
}

- (id) data {
    if (data) {
        return data;
    }
    return [self object];
}

- (id) initWithRequest:(ASIHTTPRequest *) request {
    self = [super init];
    
    if (self) {   
        [self setError:(GCError *)[request error]];
        
        if ([request responseStatusCode] >= 300) {
            NSMutableDictionary *_errorDetail = [[NSMutableDictionary alloc] init];
            [_errorDetail setValue:[[[request responseString] JSONValue] objectForKey:@"error"] forKey:NSLocalizedDescriptionKey];
            [self setError:[GCError errorWithDomain:@"GCError" code:[request responseStatusCode] userInfo:_errorDetail]];
            [_errorDetail release];
        }
        
        [self setRawResponse:[request responseString]];
        if ([[self rawResponse] length] > 1) {
            [self setObject:[[self rawResponse] JSONValue]];
        }
    }
    return self;
}

- (void) dealloc {
    [data release];
    [rawResponse release];
    [object release];
    [error release];
    [super dealloc];
}

@end