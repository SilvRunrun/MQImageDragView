//
//  ViewController.m
//  MQImageDragView
//
//  Created by ma on 16/1/25.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import "ViewController.h"
#import "MQImageDragView.h"
#import "TestTableViewCell.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,MQImageDragViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) TestTableViewCell *cell;
@end

@implementation ViewController
#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-20) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TestTableViewCell"];
    self.cell.dragView.dragViewDelegete = self;
    
    [self imageDragViewAddButtonClicked];
    [self imageDragViewAddButtonClicked];
    [self imageDragViewAddButtonClicked];
    [self imageDragViewAddButtonClicked];
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return self.cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        if (indexPath.row == 1) {
            cell.textLabel.text = @"获取高度";
        }else{
            cell.textLabel.text = @"获取照片";
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        CGFloat height = [self.cell.dragView getHeightThatFit];
        NSString *message = [NSString stringWithFormat:@"%.1f",height];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"高度" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else if (indexPath.row == 2){
        NSArray *images = [self.cell.dragView getAllImages];
        NSString *message = [NSString stringWithFormat:@"%@",images];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"照片" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [self.cell.dragView getHeightThatFit];
    }else{
        return 45;
    }
}

#pragma mark - delegate
- (void)imageDragViewAddButtonClicked{
    NSLog(@"imageDragView---点击了添加按钮");
    int randomNum = arc4random()%3+1;
    [self.cell.dragView addImage:[UIImage imageNamed:[NSString stringWithFormat:@"buttton_image%d",randomNum]]];
    
    //刷新frame
    [self.tableView reloadData];
}

- (void)imageDragViewDeleteButtonClickedAtIndex:(NSInteger)index{
    NSLog(@"imageDragView---删除了%ld",index);
    
    //刷新frame
    [self.tableView reloadData];
}

- (void)imageDragViewButtonClickedAtIndex:(NSInteger)index{
    NSLog(@"imageDragView---点击了%ld",index);
}

- (void)imageDragViewDidMoveButtonFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    NSLog(@"imageDragView---移动：从%ld至%ld",fromIndex,toIndex);
}

@end
