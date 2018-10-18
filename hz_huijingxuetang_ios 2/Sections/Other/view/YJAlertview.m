//
//  YJAlertview.m
//  TennisClass
//
//  Created by Junier on 2017/12/19.
//  Copyright © 2017年 陈燕军. All rights reserved.
//

#import "YJAlertview.h"
#import "AlertTableViewCell.h"
@interface YJAlertview()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation YJAlertview
{
    UITableView *tableview;
    NSInteger selindex;
    NSString *value;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.seltype) {
        if (_dataarr.count>0) {
            value = _dataarr[self.seltype];
        }
    }else{
        self.seltype = 0;
        if (_dataarr.count > 0) {
            value = _dataarr[self.seltype];
        }
    }
    UIView *menbanview = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    menbanview.backgroundColor = RGBA(0, 0, 0, 0.5);
    [self addSubview:menbanview];
    


    tableview = [[UITableView alloc]init];
    if (self.count <= 5) {
        tableview.frame = CGRectMake(0, self.height-60*SH-44*SH*self.count-SafeAreaBottomHeight, self.frame.size.width,44*SH*self.count);
        tableview.scrollEnabled = NO;
    }else{
            tableview.frame = CGRectMake(0, self.height-60*SH-44*SH*5-22*SH-SafeAreaBottomHeight, self.frame.size.width,44*SH*5+22*SH);
        tableview.scrollEnabled = YES;
    }
    tableview.dataSource = self;
    tableview.delegate = self;
    [self addSubview:tableview];
    
    tableview.transform = CGAffineTransformMakeTranslation(0, tableview.height+110*SW);
    [UIView animateWithDuration:0.2 animations:^{
       tableview.transform = CGAffineTransformIdentity;
    }];
    
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 50*SH)];
    topview.backgroundColor = [UIColor whiteColor];
    [self addSubview:topview];
    
    [topview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tableview.mas_top);
        make.left.equalTo(tableview.mas_left);
        make.right.equalTo(tableview.mas_right);
        make.height.equalTo(@50);
    }];
    
    topview.transform = CGAffineTransformMakeTranslation(0, tableview.height+topview.height + 60*SW+SafeAreaBottomHeight);
    [UIView animateWithDuration:0.2 animations:^{
        topview.transform = CGAffineTransformIdentity;
    }];
    
    
    UIView*ln = [[UIView alloc]initWithFrame:CGRectMake(0,49.5*SH, self.frame.size.width, 0.5)];
    ln.backgroundColor = LnColor;
    [topview addSubview:ln];
    
    UILabel *toplable = [[UILabel alloc]initWithFrame:CGRectMake(20*SH, 0, self.frame.size.width-20*SW, 50*SH)];
    toplable.text = self.typeName;
    [topview addSubview:toplable];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, kH-60*SH-SafeAreaBottomHeight, self.frame.size.width, 60*SH+SafeAreaBottomHeight)];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    UIColor *color = BtnTextColor;
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(affirmaction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    btn.transform = CGAffineTransformMakeTranslation(0, tableview.height+topview.height + 60*SW+SafeAreaBottomHeight);
    [UIView animateWithDuration:0.2 animations:^{
        btn.transform = CGAffineTransformIdentity;
    }];
    
    //添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Hide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [menbanview addGestureRecognizer:tapGestureRecognizer];
}

-(void)affirmaction{
    //这一步一般是在B跳转到A的方法中实现的，我是在B中创建了一个Button,让这个通知代理在Button中跳转方法中实现。
    if ([self.delegate respondsToSelector:@selector(changevalue:type:seltype:)]) {
        // 加入if语句就是先判断在界面A中是否有changeBgColor这个方法，当有这个方法的时候，才进行代理传值。
        //一般会先实例化出一个color的对象，在进行代理传值的时候，是带着这个color一起传递过去的。
        [self.delegate changevalue:value type:_type seltype:_seltype];
        [self removeFromSuperview];
        //这里的self是界面B，self.delegate就是界面A了（在第4步和第5步的设置中设置了）
    }
}

-(void)Hide{
    [self removeFromSuperview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataarr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alertcell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([AlertTableViewCell class]) owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.alerttitle.text  = self.dataarr[indexPath.row];
    cell.selbtn.tag  = indexPath.row + 800;
    [cell.selbtn addTarget:self action:@selector(selbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row == self.seltype) {
        cell.selbtn.selected = YES;
    }else{
        cell.selbtn.selected = NO;
    }
    return cell;
}

-(void)selbtnAction:(UIButton *)btn{
    self.seltype = btn.tag-800;
    value = _dataarr[self.seltype];
    [tableview reloadData];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.seltype = indexPath.row;
    value = _dataarr[self.seltype];
    [tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*SH;
}


@end
