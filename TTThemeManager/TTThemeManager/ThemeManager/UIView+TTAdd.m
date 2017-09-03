//
//  UIView+TTAdd.m
//  TTThemeManager
//
//  Created by Teo on 2017/9/3.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "UIView+TTAdd.h"
#import "AppDelegate.h"


@implementation UIView (TTAdd)

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (void)fullScreenshots{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIWindow *screenWindow = appDelegate.window;
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); //将截图存入相册
}

@end
