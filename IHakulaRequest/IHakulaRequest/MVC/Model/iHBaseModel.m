//
//  iHBaseModel.m
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHBaseModel.h"
#import "iHSingletonCloud.h"
#import "iHValidationKit.h"
#import "iHDummyData.h"
#import "iHDebug.h"
#import "iHCommons.h"

@interface iHBaseModel ()
- (void)returnDummyData:(NSString *)serviceName withDelegate:(id)theDelegate;
- (BOOL)checkNetwork;
@end

@implementation iHBaseModel
@synthesize theRequest, delegate;

#pragma mark - System

- (id)init
{
    self = [super init];
    if (self) {
        self.theRequest = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHRequest"];
        self.sysNetworkMonitor = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHNetworkMonitor"];
        self.sysNetworkMonitor.delegate = self;
    }
    return self;
}

#pragma mark - Error Message
- (NSString *)getErrorMessageByState:(NSString *)state {
    NSString *errorMessage = nil;
    switch ([state intValue]) {
        case 909:
            errorMessage = @"密码错误";
            break;
        case 910:
            errorMessage = @"账号不存在";
            break;
            
            
        default:
            break;
    }
    
    return errorMessage;
}


#pragma mark - iHRequestDelegate
- (void)requestDidStarted
{
    // Should be rewritten by subclass
}

- (void)requestDidCanceld
{
    // Should be rewritten by subclass
}

- (void)requestDidFinished:(iHResponseSuccess *)response
{
    // Should be rewritten by subclass
}

- (void)requestDidFailed:(iHResponseFailure *)response
{
    // Should be rewritten by subclass
    // Error code
}

#pragma mark - Service call finished result handler
- (void)serviceCallFailed:(iHResponseSuccess *)response
{
    // Should be rewritten by subclass
    // Error code
}

- (void)serviceCallSuccess:(iHResponseSuccess *)response
{
    // Should be rewritten by subclass
}


#pragma mark - Service Call
- (void)returnDummyData:(NSString *)serviceName withDelegate:(id)theDelegate {
    NSString *dummyDataPath = [[NSBundle mainBundle] pathForResource:@"DummyServiceDataTable" ofType:@"plist"];
    NSDictionary *dummyDataTable = [NSDictionary dictionaryWithContentsOfFile:dummyDataPath];
    NSString *dummyServiceFileName = [dummyDataTable objectForKey:serviceName];
    NSMutableDictionary *dummyData = [NSMutableDictionary dictionaryWithDictionary: [iHDummyData getDicFromDummyData:dummyServiceFileName]];
    
    [dummyData setValue:serviceName forKey:@"serviceName"];
    iHDINFO(@"Dummy data: %@", dummyData);
    
    id cusDelegate = theDelegate;
    if (cusDelegate && [cusDelegate respondsToSelector:@selector(requestDidFinished:)]) {
        iHResponseSuccess *successResponse = [[iHResponseSuccess alloc] initWithDic:dummyData];
        [cusDelegate requestDidFinished:successResponse];
    }
}

- (BOOL)doCallHttpService:(NSString *)serviceName withParameters:(NSDictionary *)paraDic andServiceUrl:(NSString *)serviceUrl forDelegate:(id)theDelegate
{
    NSAssert(serviceName != nil, @"doCallService:serviceName is empty");
    NSAssert(serviceUrl != nil, @"doCallService:serviceUrl is empty");
    
    if (![self checkNetwork]) {
        return NO;
    }
    
#if IH_DUMMY_DATA_SWITCH
    [self returnDummyData:serviceName withDelegate:theDelegate];
    return NO;
#endif
    
    [self->theRequest setupDefaultOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                           serviceUrl, @"serviceUrl",
                                           nil]];
    [self->theRequest callHttpService:serviceName withParameters:paraDic forDelegate:theDelegate];
    
    return YES;
}

- (BOOL)doCallService:(NSString *)serviceName withParameters:(NSDictionary *)paraDic andServiceUrl:(NSString *)serviceUrl forDelegate:(id)theDelegate
{
    NSAssert(serviceName != nil, @"doCallService:serviceName is empty");
    NSAssert(serviceUrl != nil, @"doCallService:serviceUrl is empty");
    
    if (![self checkNetwork]) {
        return NO;
    }
    
#if IH_DUMMY_DATA_SWITCH
    [self returnDummyData:serviceName withDelegate:theDelegate];
    return YES;
#endif
    
    [self->theRequest setupDefaultOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                           serviceUrl, @"serviceUrl",
                                           nil]];
    [self->theRequest callService:serviceName withParameters:paraDic forDelegate:theDelegate];
    
    return YES;
}

#pragma mark - Public Methods
- (void)networkChanged {
    if (!self.sysNetworkMonitor.isReachable) {
        [self networkUnreachable];
    } else {
//        NSString *type = nil;
//        if (self.sysNetworkMonitor.isUsing3G) {
//            type = @"3G/4G";
//        } else {
//            type = @"WIFI";
//        }
//        if (self.delegate && [self.delegate respondsToSelector:@selector(showNetworkIssue:)]) {
//            [self.delegate performSelector:@selector(showNetworkIssue:) withObject:type afterDelay:.0];
//        }
    }
}

- (void)networkUnreachable {
}

#pragma mark - Private Methods
- (NSDictionary *)getPlistDicByName:(NSString *)plistName {
    NSString *confPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:confPath];
}

- (BOOL)checkNetwork {
    if (!self.sysNetworkMonitor.isReachable) {
        if ([self.sysNetworkMonitor.networkTrafficInfo isEqualToString:@""]) {
            self.sysNetworkMonitor.networkTrafficInfo = LOCALIZED_DEFAULT_SYSTEM_TABLE(@"CheckNetWork");
        }
        
        [self networkUnreachable];
        return NO;
    }
    return YES;
}


@end
