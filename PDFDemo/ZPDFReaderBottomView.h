//
//  ZPDFReaderBottomView.h
//  PDFDemo
//
//  Created by Dennis on 27/10/2016.
//  Copyright © 2016 Kiwik. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZPDFReaderBottomViewDelegate <NSObject>

- (void)didSelectPDFPageNumber:(NSInteger)pageNumber;

@end

@interface ZPDFReaderBottomView : UIView

@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (weak, nonatomic) IBOutlet UISlider *pageSlider;
@property (weak, nonatomic) NSObject<ZPDFReaderBottomViewDelegate> *delegate;

- (void)setDispalyedTotalPageNumber:(NSInteger)total;
- (void)setDispalyedCurrentPageNumber:(NSInteger)pageNum;
@end
