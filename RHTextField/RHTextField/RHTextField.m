//
//  RHTextField.m
//  Rhino
//
//  Created by Rhino on 16/9/9.
//  Copyright © 2016年 Rhino All rights reserved.
//

#import "RHTextField.h"

#define RHAlphaNum     @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define RHAlpha        @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define RHNumbers      @"0123456789"
#define RHFloatNumbers @"0123456789."
#define RHEMail        @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.@"
#define BeginIgnoreDeprecatedWarning _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")
#define EndIgnoreDeprecatedWarning _Pragma("clang diagnostic pop")

@interface RHTextField ()

@end

@implementation RHTextField

#pragma mark - setup
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    [self addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
     self.delegate = (id<UITextFieldDelegate>) self;
}

////////设置键盘类型
- (void)setTextType:(RHTextFieldTextType)textType{
    _textType = textType;
    switch (textType) {
        case RHTextFieldTextType_Number:
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case RHTextFieldTextType_FloatNumber:
            self.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case RHTextFieldTextType_Phone:
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case RHTextFieldTextType_Character:
            self.keyboardType = UIKeyboardTypeDefault;
            break;
        case RHTextFieldTextType_AlphaNumber:
            self.keyboardType = UIKeyboardTypeDefault;
            break;
        case RHTextFieldTextType_Email:
            self.keyboardType = UIKeyboardTypeEmailAddress;
            break;
            
        default:
             self.keyboardType = UIKeyboardTypeDefault;
            break;
    }
}

#pragma mark - textFieldDelegate
/**
 *  实现该监听--联想输入并不走代理方法,不能很好的限制文本的长度
 */
- (void)textChanged
{
    BeginIgnoreDeprecatedWarning
    if (_maxTextLength) {
        NSString *toBeString = self.text;
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
        
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [self markedTextRange];
            //获取高亮部分
            UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > _maxTextLength) {
                    toBeString = [toBeString substringToIndex:_maxTextLength];
                }
            }else{ // 有高亮选择的字符串，则暂不对文字进行统计和限制
                return;
            }
        }else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (toBeString.length > _maxTextLength) {
                toBeString = [toBeString substringToIndex:_maxTextLength];
            }
        }
        self.text = toBeString;
    }
    EndIgnoreDeprecatedWarning
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (_maxTextLength) {
        if (self.markedTextRange == nil && range.location >= _maxTextLength) {
            return NO;
        }
    }
    
    NSCharacterSet *cs;
    switch (_textType) {
        case RHTextFieldTextType_Number:
            cs = [[NSCharacterSet characterSetWithCharactersInString:RHNumbers] invertedSet];
            break;
        case RHTextFieldTextType_FloatNumber:
            if (![self authFloatNumberWithRange:range string:string]) {
                return [self authFloatNumberWithRange:range string:string];
            }
            cs = [[NSCharacterSet characterSetWithCharactersInString:RHFloatNumbers] invertedSet];
            break;
        case RHTextFieldTextType_Phone:
            cs = [[NSCharacterSet characterSetWithCharactersInString:RHNumbers] invertedSet];
            break;
        case RHTextFieldTextType_Character:
            cs = [[NSCharacterSet characterSetWithCharactersInString:RHAlpha] invertedSet];
            break;
        case RHTextFieldTextType_AlphaNumber:
            cs = [[NSCharacterSet characterSetWithCharactersInString:RHAlphaNum] invertedSet];
            break;
        case RHTextFieldTextType_Email:
            cs = [[NSCharacterSet characterSetWithCharactersInString:RHEMail] invertedSet];
            break;
            
        default:
           
            return YES;
            break;
    }

    NSString *filtered =
    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    return basic;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

#pragma mark - private

/**
 *  验证只有一个小数点,开头不为小数点
 *
 *  @param range  输入框范围
 *  @param string 输入的字符串
 *
 *  @return ~
 */
- (BOOL)authFloatNumberWithRange:(NSRange)range string:(NSString *)string{
    if (range.location == 0 && [string isEqualToString:@"."]) {
        return NO;
    }
    if ([self.text rangeOfString:@"."].location != NSNotFound &&[string isEqualToString:@"."]) {
        return NO;
    }
    return YES;
}


@end
