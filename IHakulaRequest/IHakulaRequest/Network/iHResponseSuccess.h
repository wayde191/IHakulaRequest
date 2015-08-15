//
//  iHResponseSuccess.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iHResponseProtocol.h"

@interface iHResponseSuccess : NSObject <iHResponseProtocol>{
    
    NSString *serviceName;
    NSString *status;
    NSString *errorCode;
    NSDictionary *userInfoDic;
    id __weak reserve;
}

@property(nonatomic, strong) NSString *serviceName;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *errorCode;
@property(nonatomic, strong) NSDictionary *userInfoDic;
@property(nonatomic, strong) NSString *errMsg;
@property(nonatomic, weak) id reserve;


- (id)initWithDic: (NSDictionary *)dic;

@end
