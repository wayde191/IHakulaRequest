//
//  iHImageCompresser.h
//  MonkeyKing
//
//  Created by Wayde Sun on 1/8/15.
//  Copyright (c) 2015 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TARGET_MAX_SIZE         100 //KB

@interface iHImageCompresser : NSNumberFormatter {
@private
    BOOL useBaseTenUnits;
}

@property (nonatomic, readwrite, assign, getter=isUsingBaseTenUnits) BOOL useBaseTenUnits;

- (UIImage *)compressImageByMaxSize:(UIImage *)sourceImage;

@end
