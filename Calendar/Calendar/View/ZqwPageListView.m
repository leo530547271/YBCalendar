//
//  ZqwPageListVIew.m
//  ZqwPageListView
//
//  Created by 朱泉伟 on 15/8/16.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import "ZqwPageListView.h"
#import "DaysView.h"
@interface ZqwPageListView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

// 储存可视区域的视图及其index
@property (nonatomic, strong) NSMutableDictionary *visibleListViewsItems;
// 储存可循环的视图
@property (nonatomic, strong) NSMutableSet *dequeueViewPool;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL suppressScrollEvent;
@property (nonatomic, readonly) CGSize pageSize;
@property (nonatomic, readonly) NSInteger numberOfPages;

@property (nonatomic, assign) CGPoint currentOffset;

@end

@implementation ZqwPageListView

#pragma mark -
#pragma mark lazy Load
//scrollView初始化
- (UIScrollView *)scrollView{
    if (nil == _scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.frame;
        _scrollView.delegate = self;
        _scrollView.bounces = _bounces;
        _scrollView.scrollEnabled = _scrollEnabled;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (BOOL)isDragging
{
    return _scrollView.dragging;
}

- (BOOL)isDecelerating
{
    return _scrollView.decelerating;
}

#pragma mark -
#pragma mark init

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
// 进行一些基本属性设置
- (void)commonInit{
    _scrollEnabled = YES;
    _bounces = NO;

    self.visibleListViewsItems = [NSMutableDictionary dictionary];
    self.dequeueViewPool = [NSMutableSet set];
    
    [self insertSubview:self.scrollView atIndex:0];
    
    if (self.totalPagesCountBlock) {
        [self reloadData];
    }
}

#pragma mark -
#pragma mark loadView

- (void)layoutSubviews{
    [super layoutSubviews];
    [self updatePageSizeAndCount];
    [self updateScrollViewDimensions];
    [self updateScrollOffset];
    [self loadDequeueViewAndVisibleViewsIfNeeded];
    [self layOutvisibleListViews];
}
//加载某一个view 如果有原来的view，把原来的视图放入复用池
- (UIView *)loadViewAtIndex:(NSInteger)index{
    UIView *view = nil;
    view = self.loadViewAtIndexBlock(index,[self dequeueView]);
    if (view == nil){
        view = [[UIView alloc] init];
    }
    UIView *oldView = [self itemViewAtIndex:index];
    if (oldView){
        [self queueItemView:oldView];
        [oldView removeFromSuperview];
    }

    [self setItemView:view forIndex:index];
    [self setFrameForView:view atIndex:index];
    view.userInteractionEnabled = YES;
    [_scrollView addSubview:view];
    
    return view;
}
//新的可视区域，来更换可视视图池和复用视图池
- (void)loadDequeueViewAndVisibleViewsIfNeeded{
    CGFloat itemWidth = _pageSize.width;
    if (itemWidth){
        CGFloat width = self.bounds.size.width;
        
        NSInteger startIndex = [self getStartPage];
        NSInteger numberOfVisibleItems = (_scrollView.contentOffset.x/width) == 0?1:2;
        
        numberOfVisibleItems = MIN(numberOfVisibleItems, _numberOfPages);
        NSMutableSet *visibleIndices = [NSMutableSet setWithCapacity:numberOfVisibleItems];
        for (NSInteger i = 0; i < numberOfVisibleItems; i++){
            NSInteger index = i + startIndex;
            [visibleIndices addObject:@(index)];
        }
        
        for (NSNumber *number in [_visibleListViewsItems allKeys]){
            if (![visibleIndices containsObject:number]){
                UIView *view = _visibleListViewsItems[number];
                [self queueItemView:view];
                [view removeFromSuperview];
                [_visibleListViewsItems removeObjectForKey:number];
            }
        }
        for (NSNumber *number in visibleIndices){
            UIView *view = _visibleListViewsItems[number];
            if (view == nil){
                [self loadViewAtIndex:[number integerValue]];
            }
        }
    }
}
//对可视视图更新frame
- (void)layOutvisibleListViews{
    for (UIView *view in self.visibleListViews){
        [self setFrameForView:view atIndex:[self indexOfItemView:view]];
    }
}

- (void)reloadData{
    for (UIView *view in self.visibleListViews){
        [view removeFromSuperview];
    }
    
    self.visibleListViewsItems = [NSMutableDictionary dictionary];
    self.dequeueViewPool = [NSMutableSet set];
    
    [self updatePageSizeAndCount];
    
    [self setNeedsLayout];
}
//更新有多少Page和view的size
- (void)updatePageSizeAndCount{
    _numberOfPages = self.totalPagesCountBlock();
    
    CGSize size = self.bounds.size;
    if (!CGSizeEqualToSize(size, CGSizeZero)){
        _pageSize = size;
    }
    else if (_numberOfPages > 0){
        UIView *view = [[self visibleListViews] lastObject] ?: self.loadViewAtIndexBlock(0,[self dequeueView]);
        _pageSize = view.frame.size;
    }
}

#pragma mark -
#pragma mark viewManage
//根据index返回可视图  可为nil
- (UIView *)itemViewAtIndex:(NSInteger)index{
    return _visibleListViewsItems[@(index)];
}
//设置可视池的view 和对应的index
- (void)setItemView:(UIView *)view forIndex:(NSInteger)index{
    ((NSMutableDictionary *)_visibleListViewsItems)[@(index)] = view;
}
//对可视池排序
- (NSArray *)indexesForVisibleItems{
    return [[_visibleListViewsItems allKeys] sortedArrayUsingSelector:@selector(compare:)];
}
//可视池
- (NSArray *)visibleListViews{
    NSArray *indexes = [self indexesForVisibleItems];
    return [_visibleListViewsItems objectsForKeys:indexes notFoundMarker:[NSNull null]];
}
//找到可视视图的index
- (NSInteger)indexOfItemView:(UIView *)view{
    NSUInteger index = [[_visibleListViewsItems allValues] indexOfObject:view];
    if (index != NSNotFound){
        return [[_visibleListViewsItems allKeys][index] integerValue];
    }
    return NSNotFound;
}

#pragma mark -
#pragma mark viewLayout
//设置scrollView的size 和frame
- (void)updateScrollViewDimensions{
    CGSize contentSize = self.frame.size;
    self.scrollView.frame = self.bounds;
    
    contentSize.width = _pageSize.width * _numberOfPages;
    self.scrollView.contentSize = contentSize;
}
//设置视图位置
- (void)setFrameForView:(UIView *)view atIndex:(NSInteger)index{
    CGPoint center = view.center;
    center.x = (index + 0.5f) * _pageSize.width;
    view.center = center;
}
//更新scrollview的offset
- (void)updateScrollOffset{
    [self setContentOffsetWithoutEvent:CGPointMake(_scrollView.contentOffset.x, 0.0f)];
}

- (void)setContentOffsetWithoutEvent:(CGPoint)contentOffset
{
    if (!CGPointEqualToPoint(_scrollView.contentOffset, contentOffset))
    {
        BOOL animationEnabled = [UIView areAnimationsEnabled];
        if (animationEnabled) [UIView setAnimationsEnabled:NO];
        _suppressScrollEvent = YES;
        _scrollView.contentOffset = contentOffset;
        _suppressScrollEvent = NO;
        if (animationEnabled) [UIView setAnimationsEnabled:YES];
    }
}
//当前page的index
- (NSInteger)currentPageIndex{
    return roundf((float)_scrollView.contentOffset.x / _pageSize.width);
}
//scroll时初始index
- (NSInteger)getStartPage
{
    CGFloat x = _scrollView.contentOffset.x;
    return floorf((float)_scrollView.contentOffset.x/ (_pageSize.width));
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex{
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width*currentPageIndex, 0)];
}

#pragma mark -
#pragma mark View queing
// 复用池
- (void)queueItemView:(UIView *)view{
    if (view){
        [_dequeueViewPool addObject:view];
    }
}

- (UIView *)dequeueView{
    UIView *view = [_dequeueViewPool anyObject];
    if (view){
        [_dequeueViewPool removeObject:view];
    }
    return view;
}

#pragma mark -
#pragma mark scroll

- (void)didScroll{
    [self updateScrollOffset];
    
    [self layOutvisibleListViews];

    [self loadDequeueViewAndVisibleViewsIfNeeded];
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(__unused UIScrollView *)scrollView{
    if (!_suppressScrollEvent){
        _scrolling = NO;
        [self didScroll];
    }
    
    NSInteger startIndex = [self getStartPage];
    
        UIView *nextView = _visibleListViewsItems[@(startIndex+1)];
        UIView *currentView = _visibleListViewsItems[@(startIndex)];
        DaysView *nextDaysView = [nextView viewWithTag:1];
        DaysView *currentDaysView = [currentView viewWithTag:1];
        CGFloat dif = (nextDaysView.viewHeight - currentDaysView.viewHeight)/self.bounds.size.width*(self.scrollView.contentOffset.x - startIndex*_pageSize.width);
        CGFloat height = dif + 35 + 45 +currentDaysView.viewHeight;
        [[NSNotificationCenter defaultCenter] postNotificationName:YBCalendarShouldChangeHeight object:nil userInfo: @{YBCalendarRealHeight : @(height)}];
        
//    }else if(self.scrollView.contentOffset.x < self.currentOffset.x){
//        CGFloat mineStartIndex = startIndex + 1;
//        UIView *nextView = _visibleListViewsItems[@(mineStartIndex-1)];
//        UIView *currentView = _visibleListViewsItems[@(mineStartIndex)];
//        DaysView *nextDaysView = [nextView viewWithTag:1];
//        DaysView *currentDaysView = [currentView viewWithTag:1];
//        CGFloat dif = (currentDaysView.viewHeight - nextDaysView.viewHeight)/self.bounds.size.width*(self.scrollView.contentOffset.x - mineStartIndex*_pageSize.width);
//        CGFloat height = dif + 35 + 45 +currentDaysView.viewHeight;
//        [[NSNotificationCenter defaultCenter] postNotificationName:YBCalendarShouldChangeHeight object:nil userInfo: @{YBCalendarRealHeight : @(height)}];
//    }
    
}

- (void)scrollViewWillBeginDragging:(__unused UIScrollView *)scrollView{
    [self didScroll];
}

- (void)scrollViewDidEndDragging:(__unused UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate){
        [self didScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(__unused UIScrollView *)scrollView{
    
    [self didScroll];
    [[NSNotificationCenter defaultCenter] postNotificationName:YBCalendarArriveCurrentPage object:nil userInfo:@{YBCalendarCurrentPage : @([self getStartPage])}];
}

#pragma mark -
#pragma mark click



@end
