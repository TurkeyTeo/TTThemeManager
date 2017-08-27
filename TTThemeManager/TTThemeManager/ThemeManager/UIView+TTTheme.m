//
//  UIView+TTTheme.m
//  TTThemeManager
//
//  Created by Teo on 2017/8/22.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "UIView+TTTheme.h"
#import <objc/runtime.h>
#import "TTThemeManager.h"

@implementation UIView (TTTheme)

//在整个文件被加载到运行时，在 main 函数调用之前被 ObjC 运行时调用的钩子方法
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(willMoveToWindow:);
        SEL swizzledSelector = @selector(tt_willMoveToWindow:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            //主类本身没有实现需要替换的方法，而是继承了父类的实现，即 class_addMethod 方法返回 YES 。这时使用 class_getInstanceMethod 函数获取到的 originalSelector 指向的就是父类的方法，我们再通过执行 class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod)); 将父类的实现替换到我们自定义的 mrc_viewWillAppear 方法中。这样就达到了在 mrc_viewWillAppear 方法的实现中调用父类实现的目的。
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            //主类本身有实现需要替换的方法，也就是 class_addMethod 方法返回 NO 。这种情况的处理比较简单，直接交换两个方法的实现就可以了
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}


- (void)tt_willMoveToWindow:(nullable UIWindow *)newWindow{
    [self tt_willMoveToWindow:newWindow];
    [self changeThemes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeThemes) name:@"TTThemeManagerWillChangeThemes" object:nil];
}

- (void)changeThemes{
    NSLog(@"** 更换主题 %@**",[self class]);
    
    self.backgroundColor = [TTThemeManager shareInstance].tt_backgroundColor;

    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *lab = (UILabel *)self;
        lab.textColor = [TTThemeManager shareInstance].tt_textColor;
        lab.font = [TTThemeManager shareInstance].tt_textFont;
    }
    
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)self;
        [btn setTitleColor:[TTThemeManager shareInstance].tt_textColor forState:UIControlStateNormal];
        btn.titleLabel.font = [TTThemeManager shareInstance].tt_textFont;
    }
}

@end
