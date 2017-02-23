//
//  YZInputView.h
//  YZInputView
//
//  Created by yz on 16/8/1.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZInputView : UITextView

/**
 *  textView最大行数
 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;

/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, strong) void(^yz_textHeightChangeBlock)(NSString *text,CGFloat textHeight);

/**
 *  设置圆角
 */
@property (nonatomic, assign) NSUInteger cornerRadius;

/**
 *  占位文字
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 *  占位文字颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end

/**
 *  Usage:
 
 1. Initialize
 
 ```
 // 设置文本框占位文字
 _inputView.placeholder = @"请输入文字";
 
 // 监听文本框文字高度改变
 _inputView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
 // 文本框文字高度改变会自动执行这个block，修改底部View的高度
 // 设置底部条的高度 = 文字高度 + textView距离上下间距高度（10 = 上（5）下（5）间距总和）
 _bottomHCons.constant = textHeight + 10;
 };
 
 // 设置文本框最大行数
 _inputView.maxNumberOfLines = 4;
 ```
 
 2. Associate with keyboard
 ```
 // 监听键盘弹出
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
 
 
 // 键盘弹出会调用
 - (void)keyboardWillChangeFrame:(NSNotification *)note
 {
 // 获取键盘frame
 CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
 
 // 获取键盘弹出时长
 CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
 
 // 修改底部视图距离底部的间距
 _bottomCons.constant = _bottomCons.constant == 0?endFrame.size.height:0;
 
 // 约束动画
 [UIView animateWithDuration:duration animations:^{
 [self.view layoutIfNeeded];
 }];
 }
 ```
 
 3. View touch event
 ```
 -  (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
 {
 [self.view endEditing:YES];
 }
 ```
 */
