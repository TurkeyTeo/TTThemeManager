//
//  ViewController.m
//  TTThemeManager
//
//  Created by Teo on 2017/8/22.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "ViewController.h"
#import "TTThemeManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [TTThemeManager shareInstance];
    UIScrollView
    
}

- (IBAction)theme1Click:(id)sender {
    [[TTThemeManager shareInstance] tt_changeTheme:@"Theme1"];
}

- (IBAction)theme2Click:(id)sender {
    [[TTThemeManager shareInstance] tt_changeTheme:@"Theme2"];
}

- (IBAction)theme3Click:(id)sender {
    [[TTThemeManager shareInstance] tt_changeTheme:@"Theme3"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
