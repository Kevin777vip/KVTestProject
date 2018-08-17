//
//  FBCardModel.h
//  FengbangC
//
//  Created by fb on 2018/5/16.
//  Copyright © 2018 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

typedef NS_ENUM(NSInteger,FBCardType) {
    FBMainBanner,
    FBMainCarList,
    FBMainMessage,
    FBMainProductA,
    FBNoType
};



@interface TestModel :JSONModel
@property (nonatomic,copy) NSString<Optional> *abcd;
@end

@protocol TestModel;

@interface FBCardModel :JSONModel
@property (nonatomic) FBCardType cardType;
@property (nonatomic) NSArray <Optional>*material;

//main banner
@property (nonatomic) NSString <Optional>*mainBannerScrolltime;


//main carlist
@property (nonatomic) NSString <Optional>*productTitle;
@property (nonatomic) NSString <Optional>*productSubTitle;
@property (nonatomic) NSString <Optional>*rightImageUrlStr;
@property (nonatomic) NSString <Optional>*rightTextStr;
@property (nonatomic) NSString <Optional>*rightOpenUrl;
@property (nonatomic) TestModel *abcd;




@end
