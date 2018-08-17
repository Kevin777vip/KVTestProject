//
//  KVTextField.h
//  TestProject
//
//  Created by fb on 2018/8/16.
//  Copyright © 2018 fb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KVTextFieldDelegate <NSObject>
@optional
@end
@interface KVTextField : UITextField
@property (nonatomic) NSUInteger kv_allowTextLength;
@end
