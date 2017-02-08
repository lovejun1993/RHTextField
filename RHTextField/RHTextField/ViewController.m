//
//  ViewController.m
//  RHTextField
//
//  Created by Rhino on 2017/2/8.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "ViewController.h"
#import "RHTextField.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RHTextField *textField = [[RHTextField alloc]initWithFrame:CGRectMake(50, 100, 200, 30)];
    textField.maxTextLength = 10;
    textField.textType =  RHTextFieldTextType_AlphaNumber;
    textField.backgroundColor = [UIColor greenColor];
    [self.view addSubview:textField];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
