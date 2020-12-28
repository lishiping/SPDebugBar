//
//  UIDevice+LL_AppInfo.m
//
//  Copyright (c) 2018 LLDebugTool Software Foundation (https://github.com/HDB-Li/LLDebugTool)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "UIDevice+SPAppInfo.h"

#import <sys/sysctl.h>
#import <objc/runtime.h>

static const char kSPModelNameKey;

@implementation UIDevice (SPAppInfo)

- (NSString *)sp_modelName {
    
    NSString *name = objc_getAssociatedObject(self, &kSPModelNameKey);
    if (name == nil) {
        name = [self sp_getCurrentDeviceModel];
        objc_setAssociatedObject(self, &kSPModelNameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return name;
}

#pragma mark - Primary
- (NSString *)sp_getCurrentDeviceModel
{
    NSString *platform = [self sp_platform];
    if ([platform hasPrefix:@"iPhone"]) {
        if ([platform isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
        if ([platform isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
        if ([platform isEqualToString:@"iPhone13,3"])   return @"iPhone 12 Pro";
        if ([platform isEqualToString:@"iPhone13,4"])   return @"iPhone 12 Pro Max";
        
        if ([platform isEqualToString:@"iPhone12,8"])   return @"iPhone SE2";
        if ([platform isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
        if ([platform isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
        if ([platform isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
        
        if ([platform isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
        if ([platform isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
        if ([platform isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
        if ([platform isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
        
        if ([platform isEqualToString:@"iPhone10,6"])    return @"iPhone X";
        if ([platform isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
        if ([platform isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
        if ([platform isEqualToString:@"iPhone10,3"])    return @"iPhone X";
        if ([platform isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
        if ([platform isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
        
        if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
        if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
        if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
        if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
        
        if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
        if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
        if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
        
        if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
        if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
        
        if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
        if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
        if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
        if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
        if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
        if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
        if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
        if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
        if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
        if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
        return @"iPhone";
        
    } else if ([platform hasPrefix:@"iPad"]) {
        
        if ([platform isEqualToString:@"iPad11,4"])    return @"iPad Air 3";
        if ([platform isEqualToString:@"iPad11,3"])    return @"iPad Air 3";
        if ([platform isEqualToString:@"iPad11,2"])    return @"iPad Mini 5";
        if ([platform isEqualToString:@"iPad11,1"])    return @"iPad Mini 5";
        if ([platform isEqualToString:@"iPad8,8"])    return @"iPad Pro 3";
        if ([platform isEqualToString:@"iPad8,7"])    return @"iPad Pro 3";
        if ([platform isEqualToString:@"iPad8,6"])    return @"iPad Pro 3";
        if ([platform isEqualToString:@"iPad8,5"])    return @"iPad Pro 3";
        if ([platform isEqualToString:@"iPad8,4"])    return @"iPad Pro 3";
        if ([platform isEqualToString:@"iPad8,3"])    return @"iPad Pro 3";
        if ([platform isEqualToString:@"iPad8,2"])    return @"iPad Pro 3";
        if ([platform isEqualToString:@"iPad8,1"])    return @"iPad Pro 3";
        if ([platform isEqualToString:@"iPad7,6"])    return @"iPad 6";
        if ([platform isEqualToString:@"iPad7,5"])    return @"iPad 6";
        if ([platform isEqualToString:@"iPad7,4"])    return @"iPad Pro";
        if ([platform isEqualToString:@"iPad7,3"])    return @"iPad Pro";
        if ([platform isEqualToString:@"iPad7,2"])    return @"iPad Pro 2";
        if ([platform isEqualToString:@"iPad7,1"])    return @"iPad Pro 2";
        if ([platform isEqualToString:@"iPad6,12"])    return @"iPad 5";
        if ([platform isEqualToString:@"iPad6,11"])    return @"iPad 5";
        if ([platform isEqualToString:@"iPad6,8"])    return @"iPad Pro";
        if ([platform isEqualToString:@"iPad6,7"])    return @"iPad Pro";
        if ([platform isEqualToString:@"iPad6,4"])    return @"iPad Pro";
        if ([platform isEqualToString:@"iPad6,3"])    return @"iPad Pro";
        if ([platform isEqualToString:@"iPad5,4"])    return @"iPad Air 2";
        if ([platform isEqualToString:@"iPad5,3"])    return @"iPad Air 2";
        if ([platform isEqualToString:@"iPad5,2"])    return @"iPad Mini 4";
        if ([platform isEqualToString:@"iPad5,1"])    return @"iPad Mini 4";
        if ([platform isEqualToString:@"iPad4,9"])    return @"iPad Mini 3";
        if ([platform isEqualToString:@"iPad4,8"])    return @"iPad Mini 3";
        if ([platform isEqualToString:@"iPad4,7"])    return @"iPad Mini 3";
        if ([platform isEqualToString:@"iPad4,6"])    return @"iPad Mini 2";
        if ([platform isEqualToString:@"iPad4,5"])    return @"iPad Mini 2";
        if ([platform isEqualToString:@"iPad4,4"])    return @"iPad Mini 2";
        if ([platform isEqualToString:@"iPad4,3"])    return @"iPad Air";
        if ([platform isEqualToString:@"iPad4,2"])    return @"iPad Air";
        if ([platform isEqualToString:@"iPad4,1"])    return @"iPad Air";
        if ([platform isEqualToString:@"iPad3,6"])    return @"iPad 4";
        if ([platform isEqualToString:@"iPad3,5"])    return @"iPad 4";
        if ([platform isEqualToString:@"iPad3,4"])    return @"iPad 4";
        if ([platform isEqualToString:@"iPad3,3"])    return @"iPad 3";
        if ([platform isEqualToString:@"iPad3,2"])    return @"iPad 3";
        if ([platform isEqualToString:@"iPad3,1"])    return @"iPad 3";
        if ([platform isEqualToString:@"iPad2,7"])    return @"iPad Mini";
        if ([platform isEqualToString:@"iPad2,6"])    return @"iPad Mini";
        if ([platform isEqualToString:@"iPad2,5"])    return @"iPad Mini";
        if ([platform isEqualToString:@"iPad2,4"])    return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,3"])    return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,2"])    return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,1"])    return @"iPad 2";
        if ([platform isEqualToString:@"iPad1,1"])    return @"iPad 1";
        return @"iPad";
        
    } else if ([platform hasPrefix:@"iPod"]) {
        if ([platform isEqualToString:@"iPod9,1"])    return @"iPod 7";
        if ([platform isEqualToString:@"iPod7,1"])    return @"iPod 6";
        if ([platform isEqualToString:@"iPod5,1"])    return @"iPod 5";
        if ([platform isEqualToString:@"iPod4,1"])    return @"iPod 4";
        if ([platform isEqualToString:@"iPod3,1"])    return @"iPod 3";
        if ([platform isEqualToString:@"iPod2,1"])    return @"iPod 2";
        if ([platform isEqualToString:@"iPod1,1"])    return @"iPod 1";
        return @"iPod";
        
    } else {
        if ([platform isEqualToString:@"i386"])       return @"iPhone Simulator (i386)";
        if ([platform isEqualToString:@"x86_64"])     return @"iPhone Simulator (x86_64)";
    }
    return @"unknown";
}

- (NSString *)sp_platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

@end
