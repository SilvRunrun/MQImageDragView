//
//  MQImageDragView.m
//  MQImageDragView
//
//  Created by ma on 16/1/25.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import "MQImageDragView.h"
#import "MQImageButton.h"

@interface MQImageDragView () <UIGestureRecognizerDelegate>
@property (nonatomic,strong) MQImageButton *addButton;
//所有的照片按钮
@property (nonatomic,strong) NSMutableArray *allButtons;
//开始移动时候按钮的坐标
@property (nonatomic,assign) CGPoint startPointForLong;
//上次移动时候按钮的中点
@property (nonatomic,assign) CGPoint originCenterForLong;
//被移动的按钮原始index
@property (nonatomic,assign) NSInteger originIndex;
@end

@implementation MQImageDragView
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        self.kCountInRow = 4;
        self.kMarginLRTB = 20;
        self.kMarginB = 15;
        self.kMaxCount = 16;
        
        //添加按钮
        self.addButton = [[MQImageButton alloc] initWithFrame:CGRectZero];
        self.addButton.isAddButton = YES;
        [self.addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        self.addButton.buttonClickedBlock = ^(){
            if ([weakSelf.dragViewDelegete respondsToSelector:@selector(imageDragViewAddButtonClicked)]) {
                [weakSelf.dragViewDelegete imageDragViewAddButtonClicked];
            }
        };
        [self addSubview:self.addButton];
        
        //所有照片按钮的数组
        self.allButtons = [NSMutableArray arrayWithObject:self.addButton];
        
        //布局
        [self layoutAllButtonsExcept:nil animated:NO];
    }
    return self;
}

#pragma mark - setter
- (void)setKCountInRow:(CGFloat)kCountInRow{
    _kCountInRow = kCountInRow;
    [self layoutAllButtonsExcept:nil animated:NO];
}

- (void)setKMarginLRTB:(CGFloat)kMarginLRTB{
    _kMarginLRTB = kMarginLRTB;
    [self layoutAllButtonsExcept:nil animated:NO];
}

- (void)setKMarginB:(CGFloat)kMarginB{
    _kMarginB = kMarginB;
    [self layoutAllButtonsExcept:nil animated:NO];
}

- (void)setKMaxCount:(CGFloat)kMaxCount{
    _kMaxCount = kMaxCount;
    [self layoutAllButtonsExcept:nil animated:NO];
}

#pragma mark - getsture
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //获取移动的按钮
    UIView *view = gestureRecognizer.view;
    if ([view isKindOfClass:[MQImageButton class]]) {
        MQImageButton *button = (MQImageButton *)gestureRecognizer.view;
        CGPoint point = [gestureRecognizer locationInView:button];
        return ![button pointInDeleteButton:point];
    }
    return YES;
}

- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress
{
    //获取移动的按钮
    MQImageButton *button = (MQImageButton *)longPress.view;
    [self bringSubviewToFront:button];
    //获取移动差值
    CGPoint center = button.center;
    //判断添加按钮是否存在
    BOOL hasAddButton = [self.allButtons.lastObject isAddButton];
    //手势开始
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:{
            self.startPointForLong = [longPress locationInView:self];
            self.originCenterForLong = center;
            [UIView animateWithDuration:0.2 animations:^{
                CGFloat margin = 5;
                button.frame = CGRectMake(button.frame.origin.x-margin, button.frame.origin.y-margin, button.frame.size.width+2*margin, button.frame.size.height+2*margin);
                button.alpha = 0.7;
            }];
            //获取原始index
            self.originIndex = [self.allButtons indexOfObject:button];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint newPoint = [longPress locationInView:self];
            CGPoint center = self.originCenterForLong;
            center.x += newPoint.x-self.startPointForLong.x;
            center.y += newPoint.y-self.startPointForLong.y;
            button.center = center;
            
            NSInteger countInRow = self.kCountInRow;
            CGFloat marginLRTB = self.kMarginLRTB;
            CGFloat marginB = self.kMarginB;
            CGFloat viewW = self.frame.size.width;
            //计算更新位置
            CGFloat buttonWH = (viewW-2*marginLRTB-(countInRow-1)*marginB)/countInRow;
            NSInteger indexX = (center.x <= buttonWH+marginLRTB+marginB) ? 0 : (center.x-buttonWH-marginLRTB-marginB)/(buttonWH+marginB)+1;
            NSInteger indexY = (center.y <= buttonWH+marginLRTB+marginB) ? 0 : (center.y-buttonWH-marginLRTB-marginB)/(buttonWH+marginB)+1;
            NSInteger buttonIndex = indexX + indexY*countInRow;
            NSInteger count = self.allButtons.count;
            //达到最大值和没有达到最大值情况不同
            if (!hasAddButton){
                //达到最大值（没有添加按钮）
                if (buttonIndex >= count-1) {
                    buttonIndex = count-1;
                }
                [self.allButtons removeObject:button];
                [self.allButtons insertObject:button atIndex:buttonIndex];
                [self layoutAllButtonsExcept:@[button] animated:NO];
            }else{
                //未达到最大值（有添加按钮）
                if (buttonIndex >= count-1) {
                    buttonIndex = count-2;
                }
                [self.allButtons removeObject:button];
                [self.allButtons insertObject:button atIndex:buttonIndex];
                [self layoutAllButtonsExcept:@[button,self.allButtons.lastObject] animated:NO];
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:{
            [self layoutAllButtonsExcept:nil animated:YES];
            //获取移动后的index
            NSInteger newIndex =[self.allButtons indexOfObject:button];
            if ([self.dragViewDelegete respondsToSelector:@selector(imageDragViewDidMoveButtonFromIndex:toIndex:)] && newIndex != self.originIndex) {
                [self.dragViewDelegete imageDragViewDidMoveButtonFromIndex:self.originIndex toIndex:newIndex];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - layout
- (void)layoutAllButtonsExcept:(NSArray *)buttons animated:(BOOL)animated{
    //重新排列所有按钮
    NSInteger countInRow = self.kCountInRow;
    CGFloat marginLRTB = self.kMarginLRTB;
    CGFloat marginB = self.kMarginB;
    CGFloat viewW = self.frame.size.width;
    CGFloat buttonWH = (viewW-2*marginLRTB-(countInRow-1)*marginB)/countInRow;
    
    //手势处理时的动画（buttons有值的时候，忽略animated参数，默认有动画）
    if (buttons.count) {
        for (int i = 0; i<self.allButtons.count; i++) {
            [UIView animateWithDuration:0.25 animations:^{
                for (int i = 0; i<self.allButtons.count; i++) {
                    CGFloat buttonX = marginLRTB + (i%countInRow)*(buttonWH+marginB);
                    CGFloat buttonY = marginLRTB + (i/countInRow)*(buttonWH+marginB);
                    MQImageButton *button = self.allButtons[i];
                    //过滤不需要进行布局的按钮
                    BOOL isSame = NO;
                    for (MQImageButton *imageButton in buttons) {
                        if (button == imageButton){
                            isSame = YES;
                        }
                    }
                    if (isSame) {
                        continue;
                    }
                    //其它的继续布局
                    button.frame = CGRectMake(buttonX, buttonY, buttonWH, buttonWH);
                    button.alpha = 1;
                }
            }];
        }
    }
    //添加、删除的时候的动画
    else{
        if (animated) {
            for (int i = 0; i<self.allButtons.count; i++) {
                [UIView animateWithDuration:0.25 animations:^{
                    for (int i = 0; i<self.allButtons.count; i++) {
                        CGFloat buttonX = marginLRTB + (i%countInRow)*(buttonWH+marginB);
                        CGFloat buttonY = marginLRTB + (i/countInRow)*(buttonWH+marginB);
                        MQImageButton *button = self.allButtons[i];
                        button.frame = CGRectMake(buttonX, buttonY, buttonWH, buttonWH);
                        button.alpha = 1;
                    }
                }];
            }
        }else{
            for (int i = 0; i<self.allButtons.count; i++) {
                CGFloat buttonX = marginLRTB + (i%countInRow)*(buttonWH+marginB);
                CGFloat buttonY = marginLRTB + (i/countInRow)*(buttonWH+marginB);
                MQImageButton *button = self.allButtons[i];
                button.frame = CGRectMake(buttonX, buttonY, buttonWH, buttonWH);
                button.alpha = 1;
            }
        }
    }
}

#pragma mark - public
- (void)addImage:(UIImage *)image{
    //达到最大值不允许添加
    if (self.allButtons.count>=self.kMaxCount && self.allButtons.lastObject!=self.addButton) {
        return;
    }
    //添加一个照片按钮
    MQImageButton *button = [[MQImageButton alloc] initWithFrame:CGRectZero];
    [button setImage:image forState:UIControlStateNormal];
    [self addSubview:button];
    [self.allButtons addObject:button];
    
    //整理数组
    [self.allButtons removeObject:self.addButton];
    if (self.allButtons.count < self.kMaxCount) {
        [self.allButtons addObject:self.addButton];
    }else{
        //满了，刚好把addButton挤掉
        self.addButton.hidden = YES;
    }
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(button) weakbutton = button;
    //删除事件
    button.deleteButtonClickedBlock = ^(){
        //移除
        NSInteger index = [weakSelf.allButtons indexOfObject:weakbutton];
        [weakSelf.allButtons removeObject:weakbutton];
        [weakbutton removeFromSuperview];
        //添加按钮之前满的时候被隐藏了
        weakSelf.addButton.hidden = NO;
        if (![weakSelf.allButtons.lastObject isAddButton]) {
            [weakSelf.allButtons addObject:weakSelf.addButton];
        }
        //布局
        [weakSelf layoutAllButtonsExcept:nil animated:YES];
        //回调
        if ([weakSelf.dragViewDelegete respondsToSelector:@selector(imageDragViewDeleteButtonClickedAtIndex:)]) {
            [weakSelf.dragViewDelegete imageDragViewDeleteButtonClickedAtIndex:index];
        }
    };
    //点击事件
    button.buttonClickedBlock = ^(){
        //回调
        NSInteger index = [weakSelf.allButtons indexOfObject:weakbutton];
        if ([weakSelf.dragViewDelegete respondsToSelector:@selector(imageDragViewButtonClickedAtIndex:)]) {
            [weakSelf.dragViewDelegete imageDragViewButtonClickedAtIndex:index];
        }
    };
    
    //滑动手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    longPress.minimumPressDuration = 0.15;
    longPress.delegate = self;
    [button addGestureRecognizer:longPress];
    
    //布局
    [self layoutAllButtonsExcept:nil animated:NO];
}

- (NSArray *)getAllImages{
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i<self.allButtons.count; i++) {
        MQImageButton *button = self.allButtons[i];
        if (!button.isAddButton) {
            [images addObject:button.currentImage];
        }
    }
    return images;
}

- (NSArray *)getAllImageButtons{
    NSMutableArray *imageButtons = [NSMutableArray array];
    for (int i = 0; i<self.allButtons.count; i++) {
        MQImageButton *button = self.allButtons[i];
        if (!button.isAddButton) {
            [imageButtons addObject:button];
        }
    }
    return imageButtons;
}

- (CGFloat)getHeightThatFit{
    CGRect lastFrame = [self.allButtons.lastObject frame];
    return CGRectGetMaxY(lastFrame) + self.kMarginLRTB;
}

@end
