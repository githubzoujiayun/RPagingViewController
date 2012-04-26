//
//  RPagingViewController.m
//  RPagingView
//
//  Created by  on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RPagingViewController.h"

@implementation RPagingViewController
@synthesize headerHeight = _headerHeight;
@synthesize viewControllers = _viewControllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _headerHeight = 24.f;
        self.wantsFullScreenLayout = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    self.view.autoresizesSubviews = YES;
    self.view.opaque = YES;
    
    headerSlider = [[RSlideView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _headerHeight)];
    headerSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    headerSlider.pageSize = CGSizeMake(160, _headerHeight);
    headerSlider.pageMargin = 20;
    headerSlider.loopSlide = YES;
    headerSlider.delegate = self;
    headerSlider.dataSource = self;
    headerSlider.scrollView.scrollEnabled = NO;
    
    mainSlider = [[RSlideView alloc] initWithFrame:CGRectMake(0, _headerHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-_headerHeight)];
    mainSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mainSlider.loopSlide = YES;
    mainSlider.delegate = self;
    mainSlider.dataSource = self;
    
    [self.view addSubview:headerSlider];
    [self.view addSubview:mainSlider];
    
    [headerSlider release];
    [mainSlider release];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mainSlider.pageSize = mainSlider.bounds.size;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Methods

- (void)setHeaderViewBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.isViewLoaded)
        [self loadView];
    headerSlider.backgroundColor = backgroundColor;
}

- (void)setHeaderViewItemWidth:(CGFloat)width
{
    CGSize size = CGSizeMake(width, _headerHeight);
    if (!self.isViewLoaded)
        [self loadView];
    headerSlider.pageSize = size;
}

- (void)setHeaderHeight:(CGFloat)headerHeight
{
    _headerHeight = headerHeight;
    if (self.isViewLoaded) {
        CGRect frame = headerSlider.frame;
        frame.size.height = _headerHeight;
        headerSlider.frame = frame;
        
        frame = mainSlider.frame;
        frame.origin.y = _headerHeight;
        frame.size.height = CGRectGetHeight(self.view.bounds) - _headerHeight;
        mainSlider.frame = frame;
        
        CGSize size = headerSlider.pageSize;
        size.height = _headerHeight;
        headerSlider.pageSize = size;
        
        mainSlider.pageSize = mainSlider.bounds.size;
    }
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    for (UIViewController *c in viewControllers) {
        [self addChildViewController:c];
    }
    
    [headerSlider reloadData];
    [mainSlider reloadData];
}

- (void)onTitleTapped:(UIButton*)btn
{
    NSInteger idx = [headerSlider indexOfPageView:btn];
    if (idx != NSNotFound)
        [mainSlider scrollToPageAtIndex:idx];
}

#pragma mark - RSlideView Datasource

- (NSInteger)RSlideViewNumberOfPages
{
    return self.childViewControllers.count;
}

- (UIView*)RSlideView:(RSlideView *)slideView 
   viewForPageAtIndex:(NSInteger)index
{
    if (slideView == headerSlider) {
        UIButton *button = (UIButton*)[headerSlider dequeueReusableView];
        if (!button) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.textAlignment = UITextAlignmentCenter;
            [button setTitleColor:[UIColor blackColor]
                         forState:UIControlStateNormal];
            [button setTitleColor:[UIColor brownColor]
                         forState:UIControlStateHighlighted];
            [button addTarget:self
                       action:@selector(onTitleTapped:) 
             forControlEvents:UIControlEventTouchUpInside];
        }
        NSString *title = ((UIViewController*)[self.childViewControllers objectAtIndex:index]).title;
        [button setTitle:title forState:UIControlStateNormal];
        return button;
    }
    
    else if (slideView == mainSlider) {
        UIView *view = ((UIViewController*)[self.childViewControllers objectAtIndex:index]).view;
        return view;
    }
    return nil; // Should not happen
}

#pragma mark - RSlideView Delegate

- (void)RSlideView:(RSlideView *)sliderView didScrollAtPageOffset:(CGFloat)pageOffset
{
    if (sliderView == mainSlider) {
        [headerSlider scrollToPageOffset:pageOffset];
        /*
        NSInteger page = floorf(pageOffset);
        NSInteger currentPage = headerSlider.pageControl.currentPage;
        NSInteger commingPage = currentPage;
        CGFloat process = 0.f;
        if (page == currentPage) {  // move to next
            process = pageOffset - 1.f * currentPage;
            commingPage = currentPage + 1;
        }
        else {                      // move to previous
            process = 1.f * currentPage - pageOffset;
            commingPage = currentPage - 1;
        }
        
        UIView *current = [headerSlider viewOfPageAtIndex:currentPage];
        UIView *comming = [headerSlider viewOfPageAtIndex:commingPage];
        
        comming.transform = CGAffineTransformMakeScale(1.f+ 1 * process, 1.f + 1 * process);
        current.transform = CGAffineTransformMakeScale(1.f+ 1 * (1-process), 1.f + 1 * (1-process));
         */
    }

}

- (void)RSlideView:(RSlideView *)slideView tapEndOnPageAtIndex:(NSInteger)index
{
    
}

@end
