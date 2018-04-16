//
//  ViewController.m
//  SegmentPageView
//
//  Created by MenThu on 2018/4/4.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "ViewController.h"
#import "SegmentPageView.h"

@interface _TestCell : UICollectionViewCell

@property (nonatomic, weak) UILabel *textLabel;

@end

@implementation _TestCell

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

@end

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) SegmentPageView *segmentPageView;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger totalPage;

@end

@implementation ViewController

- (UIColor *)randomColor{
    CGFloat red = arc4random_uniform(256) / 255.f;
    CGFloat green = arc4random_uniform(256) / 255.f;
    CGFloat blue = arc4random_uniform(256) / 255.f;
   return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.totalPage = 8;
    
    NSMutableArray <NSString *> *pageArray = @[].mutableCopy;
    for (NSInteger index = 0; index < self.totalPage; index ++) {
        NSString *temp = [NSString stringWithFormat:@"界面=[%d]", (int)index];
        [pageArray addObject:temp];
    }
    SegmentPageView *segmentPageView = [[SegmentPageView alloc] init];
    segmentPageView.selectCallBack = ^(NSInteger index) {
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    };
    segmentPageView.pageNameArray = pageArray;
    self.contentSize = segmentPageView.segmentContentSize;
    [self.view addSubview:(_segmentPageView = segmentPageView)];
    
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[_TestCell class] forCellWithReuseIdentifier:@"_TestCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:(_collectionView = collectionView)];
    
    segmentPageView.scrollView = collectionView;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat width = MIN(viewWidth, self.contentSize.width);
    CGFloat height = 100;
    CGFloat x = (viewWidth-width)/2;
    CGFloat y = 20;
    self.segmentPageView.frame = CGRectMake(x, y, width, height);
    
    CGFloat collectionY = CGRectGetMaxY(self.segmentPageView.frame);
    CGFloat collectionHeight = viewHeight-collectionY;
    self.collectionView.frame = CGRectMake(0, collectionY, viewWidth, collectionHeight);
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(viewWidth, collectionHeight);
    self.collectionView.collectionViewLayout = layout;
}

#pragma mark - Collection代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.totalPage;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    _TestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"_TestCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    cell.contentView.backgroundColor = [self randomColor];
    return cell;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView == self.collectionView && scrollView.isDragging) {
//        NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds) + 0.5;
//        self.segmentPageView.selectPage = index;
//    }
//}


@end
