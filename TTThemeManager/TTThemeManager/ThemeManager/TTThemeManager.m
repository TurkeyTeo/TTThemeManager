//
//  TTThemeManager.m
//  TTThemeManager
//
//  Created by Teo on 2017/8/22.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "TTThemeManager.h"

NSString *const TTThemeManagerWillChangeThemes = @"TTThemeManagerWillChangeThemes";

@interface TTThemeManager ()

@property (nonatomic, strong, readwrite) NSDictionary *styles;

@end

@implementation TTThemeManager

+ (TTThemeManager *)shareInstance{
    static TTThemeManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[TTThemeManager alloc] init];
    });
    return shareInstance;
}

- (instancetype)init{
    if ([super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *theme = [defaults objectForKey:@"TTThemeManager.theme"];
        if (!theme) {
            theme = @"Theme1";
        }
        [self tt_changeTheme:theme];
    }
    return self;
}

- (void)setStyles:(NSDictionary *)styles{
    BOOL isFirstTime = _styles == nil;
    _styles = styles;
    
    if (! isFirstTime) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TTThemeManagerWillChangeThemes object:nil];
    }
}

- (void)setCurrentTheme:(NSString *)currentTheme{
    _currentTheme = currentTheme;
    
    [[NSUserDefaults standardUserDefaults] setObject:currentTheme forKey:@"TTThemeManager.theme"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)tt_changeTheme:(NSString *)themeName{
    if ([self.currentTheme isEqualToString:themeName]) {
        return;
    }
    self.currentTheme = themeName;
    
    self.styles = [self getTheme:themeName];
}


- (NSDictionary *)getTheme:(NSString *)themeName{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Theme" ofType:@"plist"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    if (dic) {
        NSDictionary *data = dic[themeName];
        if (data) {
            return data;
        }
    }
    return nil;
}


// Return a UIFont from theme file
- (UIFont *)tt_textFont{
    NSString *fontName = self.styles[@"textFont"];
    NSString *fontSize = self.styles[@"textSize"];
    UIFont *font = [UIFont fontWithName:fontName size:fontSize.floatValue];
    if (!font) {
        font = [UIFont systemFontOfSize:16];
    }
    return font;
}

// Return a UIColor from a hex color stored in theme file
- (UIColor *)tt_textColor{
    return [self colorFromString:self.styles[@"textColor"]] ?:[UIColor blackColor];
}


// Return a UIColor from a hex color stored in theme file
- (UIColor *)tt_backgroundColor{
    return [self colorFromString:self.styles[@"backgroundColor"]] ?:[UIColor whiteColor];
}


// Return a UIImage for an image name stored in theme file
- (UIImage *)tt_imageForKey:(NSString *)key{
    return [UIImage imageNamed:key];
}



- (UIColor*)colorFromString:(NSString*)hexStr {
    hexStr = [hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([hexStr hasPrefix:@"0x"]) {
        hexStr = [hexStr substringFromIndex:2];
    }
    if([hexStr hasPrefix:@"#"]) {
        hexStr = [hexStr substringFromIndex:1];
    }
    
    NSUInteger hex = [self intFromHexString:hexStr];
    return DKColorFromRGB(hex);
}

- (NSUInteger)intFromHexString:(NSString *)hexStr {
    unsigned int hexInt = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    [scanner scanHexInt:&hexInt];
    return hexInt;
}

UIColor *DKColorFromRGB(NSUInteger hex) {
    return [UIColor colorWithRed:((CGFloat)((hex >> 16) & 0xFF)/255.0) green:((CGFloat)((hex >> 8) & 0xFF)/255.0) blue:((CGFloat)(hex & 0xFF)/255.0) alpha:1.0];
}

@end
