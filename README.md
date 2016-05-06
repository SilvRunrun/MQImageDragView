# MQImageDragView


## 概述

**iOS端仿微博的图片选择器，在发布新微博或者新状态时从相册选择完照片的照片容器，支持删除及拖动排序。**


![screenShot1](http://chuantu.biz/t4/8/1462498826x3738746523.jpg)
![screenShot2](http://chuantu.biz/t4/8/1462498900x3738746523.jpg)


## 用法

####1.初始化

```
//初始化时请设定宽度，高度不需设定（内部计算）
MQImageDragView *dragView = [[MQImageDragView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
//上下左右的间距
dragView.kMarginLRTB = 5;
//图片之间的间距
dragView.kMarginB = 5;
//最大图片数量
dragView.kMaxCount = 9;
//每行的图片数量
dragView.kCountInRow = 3;
[self.view addSubview:self.dragView];
```

####2.公开方法

```
//添加一张照片
- (void)addImage:(UIImage *)image;
//获取所有照片
- (NSArray *)getAllImages;
//获取所有装图片的按钮
- (NSArray *)getAllImageButtons;
//获取本视图适当的高度（放入tableView中时，计算cell高度用）
- (CGFloat)getHeightThatFit;
```

####3.代理方法

```
//点击了添加按钮
- (void)imageDragViewAddButtonClicked;
//点击了删除按钮
- (void)imageDragViewDeleteButtonClickedAtIndex:(NSInteger)index;
//点击了某张图片
- (void)imageDragViewButtonClickedAtIndex:(NSInteger)index;
//移动了图片
- (void)imageDragViewDidMoveButtonFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
```
