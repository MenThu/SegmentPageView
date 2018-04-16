//
//  SegmentPageView.m
//  SegmentPageView
//
//  Created by MenThu on 2018/4/4.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "SegmentPageView.h"
#import "UIColor+Exten.h"

@interface _SegmentPageCell : UICollectionViewCell

@property (nonatomic, weak) UILabel *textLabel;
- (void)setTitle:(NSString *)title withHexColor:(NSString *)hexColor;

@end

@implementation _SegmentPageCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *textLabel = [UILabel new];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.numberOfLines = 1;
        [self.contentView addSubview:(_textLabel = textLabel)];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = self.contentView.bounds;
}

- (void)setTitle:(NSString *)title withHexColor:(NSString *)hexColor{
    self.textLabel.text = title;
    self.textLabel.textColor = [UIColor colorWithHexString:hexColor alpha:1];
}

@end

@interface SegmentPageView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <NSNumber *> *sizeArray;
@property (nonatomic, weak) UIView *bottomLineView;
@property (nonatomic, assign) CGFloat bottomLineHeight;
@property (nonatomic, assign, readwrite) CGSize segmentContentSize;

@end

@implementation SegmentPageView

#pragma mark - LifeCircle
- (instancetype)init{
    if (self = [super init]) {
        [self configView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    [self moveLineBelowRow:self.selectPage];
}

- (void)dealloc{
    [self removeKvoForScrollView:self.scrollView];
}

#pragma mark - Private
- (void)configView{
    _unSelectColorHex = @"333333";
    _selectColorHex = @"FFA500";
    _horizontalSpace = 10.f;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.sectionInset = UIEdgeInsetsMake(0, self.horizontalSpace, 0, self.horizontalSpace);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor cyanColor];
    [collectionView registerClass:[_SegmentPageCell class] forCellWithReuseIdentifier:@"_SegmentPageCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:(_collectionView = collectionView)];
    
    self.bottomLineHeight = 2;
    UIView *bottomLineView = [UIView new];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:_selectColorHex alpha:1];
    [self.collectionView addSubview:(_bottomLineView = bottomLineView)];
}

- (void)letOutSideConfigCell{
    if (![self.pageNameArray isKindOfClass:[NSArray class]] || self.pageNameArray.count <= 0) {
        return;
    }
    
    if (![self.unSelectColorHex isKindOfClass:[NSString class]] || self.unSelectColorHex.length <= 0) {
        return;
    }
    
    if (![self.selectColorHex isKindOfClass:[NSString class]] || self.selectColorHex.length <= 0) {
        return;
    }

    [self.collectionView reloadData];
}

- (void)moveLineBelowRow:(NSInteger)row{
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    if (self.pageNameArray.count <= 0 || self.selectPage > self.pageNameArray.count-1 || viewHeight <= 0) {
        return;
    }
    
    CGFloat x = self.horizontalSpace;
    CGFloat y = viewHeight - self.bottomLineHeight;
    CGFloat width = self.sizeArray[self.selectPage].floatValue;
    for (NSInteger index = 0; index < self.selectPage; index ++) {
        x += self.sizeArray[index].floatValue + self.horizontalSpace;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bottomLineView.frame = CGRectMake(x, y, width, weakSelf.bottomLineHeight);
    }];
}

- (void)removeKvoForScrollView:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UIScrollView class]]) {
        [scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:nil];
    }
}

- (void)addKvoFroScrollView:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UIScrollView class]]) {
        [scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

#pragma mark - Setter
- (void)setHorizontalSpace:(CGFloat)horizontalSpace{
    _horizontalSpace = horizontalSpace;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = self.horizontalSpace;
    layout.sectionInset = UIEdgeInsetsMake(0, self.horizontalSpace, 0, self.horizontalSpace);
    self.collectionView.collectionViewLayout = layout;
}

- (void)setUnSelectColorHex:(NSString *)unSelectColorHex{
    _unSelectColorHex = unSelectColorHex;
    [self letOutSideConfigCell];
}

- (void)setSelectColorHex:(NSString *)selectColorHex{
    _selectColorHex = selectColorHex;
    [self letOutSideConfigCell];
}

- (void)setSelectPage:(NSInteger)selectPage{
    if (_selectPage == selectPage || selectPage > self.pageNameArray.count-1) {
        return;
    }
    NSInteger lastSelectIndex = _selectPage;
    _selectPage = selectPage;
    NSIndexPath *lastSelectIndexPath = [NSIndexPath indexPathForRow:lastSelectIndex inSection:0];
    NSIndexPath *currentSelectIndexPath = [NSIndexPath indexPathForRow:_selectPage inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:@[lastSelectIndexPath]];
    [self.collectionView reloadItemsAtIndexPaths:@[currentSelectIndexPath]];
    [self.collectionView scrollToItemAtIndexPath:currentSelectIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self moveLineBelowRow:_selectPage];
}

- (void)setPageNameArray:(NSArray<NSString *> *)pageNameArray{
    _pageNameArray = pageNameArray;
    NSMutableArray <NSNumber *> *sizeArray = @[].mutableCopy;
    _SegmentPageCell *tempCell = [[_SegmentPageCell alloc] init];
    CGSize maxSize = CGSizeMake(MAXFLOAT, tempCell.textLabel.font.lineHeight);
    CGFloat contentWidth = 0;//左右的sectionInset间隙
    for (NSString *text in pageNameArray) {
        tempCell.textLabel.text = text;
        CGFloat fitWidth = [tempCell.textLabel sizeThatFits:maxSize].width;
        contentWidth += (self.horizontalSpace+fitWidth);
        [sizeArray addObject:@(fitWidth)];
    }
    contentWidth+=self.horizontalSpace;
    self.sizeArray = sizeArray;
    self.segmentContentSize = CGSizeMake(contentWidth, tempCell.textLabel.font.lineHeight+10);
    [self.collectionView reloadData];
}

- (void)setScrollView:(UIScrollView *)scrollView{
    [self removeKvoForScrollView:_scrollView];
    _scrollView = scrollView;
    [self addKvoFroScrollView:_scrollView];
}

#pragma mark - Collection代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pageNameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    _SegmentPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"_SegmentPageCell" forIndexPath:indexPath];
    NSString *hexColor = (indexPath.row == self.selectPage ? self.selectColorHex : self.unSelectColorHex);
    [cell setTitle:self.pageNameArray[indexPath.row] withHexColor:hexColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectPage = indexPath.row;
    if (self.selectCallBack) {
        self.selectCallBack(self.selectPage);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.sizeArray[indexPath.row].floatValue, CGRectGetHeight(self.bounds));
}

#pragma mark - KVO回调
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(__unused id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if(object == self.scrollView) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.bounds);
            if (scrollViewWidth <= 0 || !self.scrollView.isDragging) {
                return;
            }
            CGPoint offsetPoint = [change[NSKeyValueChangeNewKey] CGPointValue];
            NSInteger page = offsetPoint.x / scrollViewWidth + 0.5;
            self.selectPage = page;
        }
    }
}

@end
