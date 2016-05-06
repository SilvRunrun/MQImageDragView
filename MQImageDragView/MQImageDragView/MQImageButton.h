//
//  MQImageButton.h
//  MQImageDragView
//
//  Created by ma on 16/1/25.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MQImageButton : UIButton
@property (nonatomic,copy) void(^deleteButtonClickedBlock)();
@property (nonatomic,copy) void(^buttonClickedBlock)();
@property (nonatomic,assign) BOOL isAddButton;
- (BOOL)pointInDeleteButton:(CGPoint)point;
@end
