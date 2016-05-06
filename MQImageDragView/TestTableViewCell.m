//
//  TestTableViewCell.m
//  MQImageDragView
//
//  Created by ma on 16/1/25.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import "TestTableViewCell.h"
#import "MQImageDragView.h"

@interface TestTableViewCell ()
@end

@implementation TestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dragView = [[MQImageDragView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
        self.dragView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.06];
        self.dragView.kMarginLRTB = 5;
        self.dragView.kMarginB = 5;
        self.dragView.kMaxCount = 9;
        self.dragView.kCountInRow = 3;
        [self.contentView addSubview:self.dragView];
    }
    return self;
}

- (void)layoutSubviews{
    self.dragView.frame = self.bounds;
}

@end
