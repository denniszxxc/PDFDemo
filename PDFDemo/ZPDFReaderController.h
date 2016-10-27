//
//  ZPDFReaderController.h
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPDFPageModel.h"
#import "ZPDFReaderBottomView.h"

@interface ZPDFReaderController : UIViewController<ZPDFPageModelDelegate, ZPDFReaderBottomViewDelegate, UIPageViewControllerDelegate>

@property(nonatomic,copy)NSString *fileName, *subDirName;
@end
