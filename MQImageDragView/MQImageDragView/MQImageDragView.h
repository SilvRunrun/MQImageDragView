//
//  MQImageDragView.h
//  MQImageDragView
//
//  Created by ma on 16/1/25.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MQImageDragViewDelegate <NSObject>
@optional
/** 点击了添加按钮 */
- (void)imageDragViewAddButtonClicked;
/** 点击了删除按钮 */
- (void)imageDragViewDeleteButtonClickedAtIndex:(NSInteger)index;
/** 点击了按钮 */
- (void)imageDragViewButtonClickedAtIndex:(NSInteger)index;
/** 移动了按钮 */
- (void)imageDragViewDidMoveButtonFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
@end

@interface MQImageDragView : UIScrollView
@property (nonatomic,assign) CGFloat kCountInRow;   //每行个数
@property (nonatomic,assign) CGFloat kMarginLRTB;   //上下左右间距
@property (nonatomic,assign) CGFloat kMarginB;      //按钮间距
@property (nonatomic,assign) CGFloat kMaxCount;     //最大数量

/** 代理 */
@property (nonatomic,weak) id<MQImageDragViewDelegate> dragViewDelegete;
/** 添加一张照片 */
- (void)addImage:(UIImage *)image;
/** 获取所有照片 */
- (NSArray *)getAllImages;
/** 获取所有按钮 */
- (NSArray *)getAllImageButtons;
/** 获取本视图适当的高度 */
- (CGFloat)getHeightThatFit;
@end
