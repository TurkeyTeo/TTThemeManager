//
//  TTThemeManager.m
//  TTThemeManager
//
//  Created by Teo on 2017/8/22.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "TTThemeManager.h"
#import "UIHelper.h"

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
    return [UIHelper colorFromString:self.styles[@"textColor"]] ?:[UIColor blackColor];
}


// Return a UIColor from a hex color stored in theme file
- (UIColor *)tt_backgroundColor{
    return [UIHelper colorFromString:self.styles[@"backgroundColor"]] ?:[UIColor whiteColor];
}


// Return a UIImage for an image name stored in theme file
- (UIImage *)tt_imageForKey:(NSString *)key{
    return [UIImage imageNamed:key];
}






@end
