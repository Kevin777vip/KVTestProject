//
//  KVTextField.m
//  TestProject
//
//  Created by fb on 2018/8/16.
//  Copyright © 2018 fb. All rights reserved.
//

#import "KVTextField.h"
@interface KVTextField()<UITextFieldDelegate>

@end

@implementation KVTextField

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.kv_allowTextLength>0) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if (textField.text.length >= self.kv_allowTextLength) {
            textField.text = [textField.text substringToIndex:self.kv_allowTextLength];
            return NO;
        }
    }
    return YES;
}

@end
