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
        [self setUpNoti];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        [self setUpNoti];
    }
    return self;
}

-(void)setUpNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTextLimit) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)checkTextLimit{
    if (self.kv_allowTextLength>0) {
        if (self.text.length >= self.kv_allowTextLength) {
            self.text = [self.text substringToIndex:self.kv_allowTextLength];
        }
    }
}
@end
