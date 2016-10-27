//
//  ZPDFReaderBottomView.m
//  PDFDemo
//
//  Created by Dennis on 27/10/2016.
//  Copyright © 2016 Kiwik. All rights reserved.
//

#import "ZPDFReaderBottomView.h"

@interface ZPDFReaderBottomView ()

@property (assign, nonatomic) NSInteger totalPageNum;
@property (assign, nonatomic) NSInteger currentPageNum;

@end

@implementation ZPDFReaderBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.totalPageNum = 1;
    self.currentPageNum = 1;

}
- (IBAction)slideValueDidChange:(UISlider *)sender {
    int discreteValue = roundl([sender value]); // Rounds float to an integer
    [sender setValue:(float)discreteValue];
    
    if (discreteValue != self.currentPageNum) {
        [self setDispalyedCurrentPageNumber:discreteValue];
        
        if ([self.delegate respondsToSelector:@selector(didSelectPDFPageNumber:)]) {
            [self.delegate didSelectPDFPageNumber:discreteValue];
        }
    }
}

#pragma mark - Public Methods
- (void)setDispalyedTotalPageNumber:(NSInteger)total {
    self.pageNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.currentPageNum, total];
    self.pageSlider.maximumValue = 1.0f * total;
    
    self.totalPageNum = total;
    
    if (self.totalPageNum == 1) {
        self.pageSlider.hidden = YES;
        self.pageNumberLabel.hidden = YES;
    }
}
- (void)setDispalyedCurrentPageNumber:(NSInteger)pageNum {
    self.pageNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld", pageNum, self.totalPageNum];
    self.pageSlider.value = 1.0f * pageNum;
    
    self.currentPageNum = pageNum;
}
@end
