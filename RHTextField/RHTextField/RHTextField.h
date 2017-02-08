//
//  RHTextField.h
//  Rhino 
//
//  Created by Rhino on 16/9/9.
//  Copyright © 2016年 Rhino All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RHTextFieldTextType) {
    RHTextFieldTextType_Default,
    RHTextFieldTextType_Number,//数字
    RHTextFieldTextType_FloatNumber,//包含小数
    RHTextFieldTextType_Phone,//电话号码
    RHTextFieldTextType_Character,//英文字母
    RHTextFieldTextType_AlphaNumber,//英文字母+数字
    RHTextFieldTextType_Email,
    //RHTextFieldTextType_,//无特殊字符
};

/**
 *  简单的根据类型和最大文本长度 限制输入框输入
 */
@interface RHTextField : UITextField

//////最大允许输入文本长度
@property (nonatomic,assign)NSInteger maxTextLength;
//////文本框输入文本的类型
@property (nonatomic,assign)RHTextFieldTextType textType;


@end
