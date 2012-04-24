//
//  RPagingViewController.h
//  RPagingView
//
//  Created by  on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSlideView.h"


@interface RPagingViewController : UIViewController <RSlideViewDelegate,RSlideViewDataSource>
{
    RSlideView                  * headerSlider;
    RSlideView                  * mainSlider;
}

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) NSArray *viewControllers;

- (void)setHeaderViewBackgroundColor:(UIColor*)backgroundColor;
- (void)setHeaderViewItemWidth:(CGFloat)width;
@end
