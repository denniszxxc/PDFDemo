//
//  ZPDFReaderController.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFReaderController.h"
#import "ZPDFPageController.h"

#define IOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)

@implementation ZPDFReaderController
{
    UIPageViewController *pageViewCtrl;
    ZPDFPageModel *pdfPageModel;
    ZPDFReaderBottomView *bottomView;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [self.fileName substringToIndex:self.fileName.length-4];
    
    if(IOS7)
    {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    //initial UIPageViewController
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    pageViewCtrl = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                   navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                 options:options];
    
    //setting DataSource
    CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)self.fileName, NULL, (__bridge CFStringRef)self.subDirName);
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    CFRelease(pdfURL);
    pdfPageModel = [[ZPDFPageModel alloc] initWithPDFDocument:pdfDocument];
    pdfPageModel.delegate=self;
    [pageViewCtrl setDataSource:pdfPageModel];
    [pageViewCtrl setDelegate:self];
    
    NSInteger page = [[NSUserDefaults standardUserDefaults] integerForKey:_fileName];
    
    //setting initial VCs
    ZPDFPageController *initialViewController = [pdfPageModel viewControllerAtIndex:MAX(page, 1)];
    NSArray *viewControllers = @[initialViewController];
    [pageViewCtrl setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    //show UIPageViewController
    [self addChildViewController:pageViewCtrl];
    [self.view addSubview:pageViewCtrl.view];
    [pageViewCtrl didMoveToParentViewController:self];
    
    
    // Add BottomView
    bottomView = [[[NSBundle mainBundle] loadNibNamed:@"ZPDFReaderBottomView" owner:self options:nil] objectAtIndex:0];
    bottomView.frame = CGRectMake(0, self.view.bounds.size.height - bottomView.frame.size.height, self.view.bounds.size.width, bottomView.frame.size.height);
    [self.view addSubview:bottomView];
    // Setup bottomView
    [bottomView setDispalyedTotalPageNumber:CGPDFDocumentGetNumberOfPages(pdfDocument)];
    [bottomView setDispalyedCurrentPageNumber:MAX(page, 1)];
    [bottomView setDelegate:self];
    
    // Change pageViewCtrlSize, Avoid overlapping with the BottomView
    pageViewCtrl.view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    pageViewCtrl.view.frame = CGRectMake(pageViewCtrl.view.frame.origin.x,
                                         pageViewCtrl.view.frame.origin.y,
                                         pageViewCtrl.view.frame.size.width,
                                         pageViewCtrl.view.frame.size.height - bottomView.frame.size.height);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

-(void)pageChanged:(NSInteger)page
{
    [[NSUserDefaults standardUserDefaults] setInteger:page forKey:_fileName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ZPDFReaderBottomViewDelegate
- (void)didSelectPDFPageNumber:(NSInteger)pageNumber {
    NSInteger currentIndex = [pdfPageModel indexOfViewController:[pageViewCtrl.viewControllers firstObject]];
    if (pageNumber == currentIndex) {
        return;
    }
    
    ZPDFPageController *targetViewController = [pdfPageModel viewControllerAtIndex:pageNumber];
    NSArray *viewControllers = @[targetViewController];
    
    UIPageViewControllerNavigationDirection direction = pageNumber > currentIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [pageViewCtrl setViewControllers:viewControllers direction:direction animated:YES completion:nil];
}

#pragma mark - UIPageViewControllerDelegate 
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSInteger currentIndex = [pdfPageModel indexOfViewController:[pageViewCtrl.viewControllers firstObject]];
    [bottomView setDispalyedCurrentPageNumber:currentIndex];
}
@end
