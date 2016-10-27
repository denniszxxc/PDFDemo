//
//  ZPDFView.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFView.h"

@implementation ZPDFView

-(id)initWithFrame:(CGRect)frame atPage:(int)index withPDFDoc:(CGPDFDocumentRef) pdfDoc{
    self = [super initWithFrame:frame];
    if(self){
        pageNO = index;
        pdfDocument = pdfDoc;
        
        // Uses CATiledLayer to Improve pdf quality when zoomed-in
        CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        tiledLayer.levelsOfDetail = 4;
        tiledLayer.levelsOfDetailBias = 2;
        tiledLayer.tileSize = self.frame.size;  // Avoid to many boxes
    }
    return self;
}

+ (Class)layerClass
{
    return [CATiledLayer class];
}

-(void)drawInContext:(CGContextRef)context atPageNo:(int)page_no{
    // PDF page drawing expects a Lower-Left coordinate system, so we flip the coordinate system
    // before we start drawing.
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    if (pageNO == 0) {
        pageNO = 1;
    }
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocument, pageNO);
    CGContextSaveGState(context);
    {
        CGRect rect = CGRectInset(self.bounds, 0, 0);
        CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, rect, 0, true);
        CGContextConcatCTM(context, pdfTransform);
        CGContextDrawPDFPage(context, page);
    }
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    //画PDF内容
    [self drawInContext:context atPageNo:pageNO];
}

@end
