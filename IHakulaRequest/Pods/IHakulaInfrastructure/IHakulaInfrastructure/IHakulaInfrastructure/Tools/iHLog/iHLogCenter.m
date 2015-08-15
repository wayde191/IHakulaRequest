//
//  iHLogCenter.m
//  Korpen
//
//  Created by Wayde Sun on 3/14/13.
//  Copyright (c) 2013 Symbio. All rights reserved.
//

#import "iHLogCenter.h"
#import "iHFileManager.h"
#import "iHLog.h"

@interface iHLogCenter ()
@end

@implementation iHLogCenter

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    _requestQueue = nil;
}

#pragma mark - Public Methods
- (void)uploadLogs {
    
}

@end
