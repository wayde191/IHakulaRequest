//
//  iHImageCompresser.m
//  MonkeyKing
//
//  Created by Wayde Sun on 1/8/15.
//  Copyright (c) 2015 MK. All rights reserved.
//

static const char sUnits[] = { '\0', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y' };
static int sMaxUnits = sizeof sUnits - 1;

#import "iHImageCompresser.h"
#import "iHDebug.h"
#import "UIImage+iHAddition.h"

@implementation iHImageCompresser
@synthesize useBaseTenUnits;

#pragma mark - Public Methods
- (UIImage *)compressImageByMaxSize:(UIImage *)sourceImage {
    return [self compressImage:sourceImage toTargetSize:TARGET_MAX_SIZE];
}

#pragma mark - Private Methods
- (UIImage *)compressImage:(UIImage *)sourceImage toTargetSize:(CGFloat) targetSize{
    
    targetSize = 1024 * targetSize;
    
    CGFloat width =  sqrt(targetSize * sourceImage.size.width / sourceImage.size.height);
    CGFloat height = width * sourceImage.size.height / sourceImage.size.width;
    
    if (width > sourceImage.size.width && height > sourceImage.size.height) {
        return sourceImage;
    }
    
    sourceImage = [UIImage imageCompressForSize:sourceImage targetSize:CGSizeMake(width, height)];
    
    NSData *idenData = UIImageJPEGRepresentation(sourceImage, 1);
    
    NSNumber *sizeAttrib = [NSNumber numberWithInteger:idenData.length];
    NSString *sizeStr = [self getSizeStr:sizeAttrib];
    
    NSArray *sizeArr = [ sizeStr componentsSeparatedByString:@" "];
    if ([sizeArr[1] isEqualToString:@"MB"]) {
        CGFloat nextSize = (sourceImage.size.width / 2) * (sourceImage.size.height / 2) / 1024;
        return [self compressImage:sourceImage toTargetSize:nextSize];
        
    }  else if ([sizeArr[1] isEqualToString:@"KB"]) {
        CGFloat realSize = [sizeArr[0] floatValue];
        if (realSize > TARGET_MAX_SIZE) {
            CGFloat nextSize = TARGET_MAX_SIZE / (realSize / TARGET_MAX_SIZE);
            iHDINFO(@"\n---- %f\n", nextSize);
            return [self compressImage:sourceImage toTargetSize:nextSize];
        } else {
            return sourceImage;
        }
    }
    
    return sourceImage;
}

- (NSString *)getSizeStr:(NSNumber *)sizeAttrib {
    NSString *sizeString = nil;
    
    [self setMaximumFractionDigits:2];
    sizeString = [self stringFromNumber:sizeAttrib];
    iHDINFO(@" 1024 ---- %@", sizeString);
    
    [self setUseBaseTenUnits:YES];
    sizeString = [self stringFromNumber:sizeAttrib];
    iHDINFO(@" 1000 ---- %@", sizeString);
    
    return sizeString;
}

- (NSString *) stringFromNumber:(NSNumber *)number
{
    int multiplier = useBaseTenUnits ? 1000 : 1024;
    int exponent = 0;
    
    double bytes = [number doubleValue];
    
    while ((bytes >= multiplier) && (exponent < sMaxUnits)) {
        bytes /= multiplier;
        exponent++;
    }
    
    return [NSString stringWithFormat:@"%@ %cB", [super stringFromNumber: [NSNumber numberWithDouble: bytes]], sUnits[exponent]];
}

@end
