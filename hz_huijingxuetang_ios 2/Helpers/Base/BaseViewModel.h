//
//  BaseViewModel.h
//  ZhuanMCH
//
//  Created by txooo on 16/8/31.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModelProtocol.h"
#import "JSLoadingView.h"
typedef NS_ENUM(NSUInteger, BMTitleViewType) {
    /// System title view
    BMTitleViewTypeDefault,
    /// Double title view
    BMTitleViewTypeDoubleTitle,
    /// Loading title view
    BMTitleViewTypeLoadingTitle
};

@interface BaseViewModel : NSObject<BaseViewModelProtocol>

@property (nonatomic, copy, readonly) NSDictionary *params;

@property (nonatomic,assign) BMTitleViewType titleViewType;

@property (nonatomic,assign) BOOL showActivityView;

@property (nonatomic,copy) NSString *subTitle;

@property (nonatomic,strong) RACCommand *loadDataCommand;

@property (nonatomic,strong) RACCommand *universalCommand;

@property (nonatomic,strong) JSLoadingView *loadingView;

@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;

@property (nonatomic,strong) RACSubject *backSuject;

@end
