//
//  TTThemeManager.h
//  TTThemeManager
//
//  Created by Teo on 2017/8/22.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const TTThemeManagerWillChangeThemes;


@interface TTThemeManager : NSObject

@property (nonatomic, copy, readonly) NSString *currentTheme;

+ (TTThemeManager *)shareInstance;

//change Theme
- (void)tt_changeTheme:(NSString *)themeName;

// Return a UIColor from a hex color stored in theme file
- (UIColor *)tt_backgroundColor;

// Return a UIFont from theme file
- (UIFont *)tt_textFont;

// Return a UIColor from a hex color stored in theme file
- (UIColor *)tt_textColor;

// Return a UIImage for an image name stored in theme file
- (UIImage *)tt_imageForKey:(NSString *)key;



@end
