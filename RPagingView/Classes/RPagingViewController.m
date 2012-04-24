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
    headerSlider.pageSize = CGSizeMake(140, _headerHeight);
    headerSlider.delegate = self;
    headerSlider.dataSource = self;
    
    mainSlider = [[RSlideView alloc] initWithFrame:CGRectMake(0, _headerHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-_headerHeight)];
    mainSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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

- (void)setViewControllers:(NSArray *)viewControllers
{
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    for (UIViewController *c in viewControllers) {
        [self addChildViewController:c];
    }
    
    [headerSlider reloadData];
    [mainSlider reloadData];
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
        UILabel *label = (UILabel*)[headerSlider dequeueReusableView];
        if (!label) {
            label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 24)] autorelease];
            label.textAlignment = UITextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
        }
        label.text = ((UIViewController*)[self.childViewControllers objectAtIndex:index]).title;
        return label;
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
    }
}

- (void)RSlideView:(RSlideView *)slideView tapEndOnPageAtIndex:(NSInteger)index
{
    
}

@end
