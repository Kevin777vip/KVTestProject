//
//  HomePageModel.h
//  FengbangC
//
//  Created by fb on 2018/6/13.
//  Copyright © 2018 kevin. All rights reserved.
//

#import "JSONModel.h"
#import "FBCardModel.h"
@protocol FBCardModel;

@interface HomePageModel : JSONModel
@property (nonatomic) FBCardModel<Optional> *data;
@property (nonatomic) NSString <Optional>*msg;
@property (nonatomic) BOOL testIf;
@end
