//
//  SegmentPageView.h
//  SegmentPageView
//
//  Created by MenThu on 2018/4/4.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentPageView : UIView

/** 被监听的列表页 */
@property (nonatomic, weak) UIScrollView *scrollView;

/** 每一栏的名称 */
@property (nonatomic, strong) NSArray <NSString *> *pageNameArray;

/** 视图的内容 */
@property (nonatomic, assign, readonly) CGSize segmentContentSize;

/** 选中的页数 */
@property (nonatomic, assign) NSInteger selectPage;

/** 未被选中时，字体的颜色 */
@property (nonatomic, copy) NSString *unSelectColorHex;

/** 被选中时，字体的颜色 */
@property (nonatomic, copy) NSString *selectColorHex;

/** 选中了哪一页 */
@property (nonatomic, copy) void (^selectCallBack) (NSInteger index);

/** 单元格的水平间隙，默认为10 */
@property (nonatomic, assign) CGFloat horizontalSpace;

@end
