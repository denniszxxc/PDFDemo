//
//  ZPDFListViewController.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFListViewController.h"
#import "ZPDFReaderController.h"

@interface ZPDFListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain)NSArray *titleArray;
@property (nonatomic, retain)NSArray *fileArray;

@end

@implementation ZPDFListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"PDF浏览Demo";
    self.view.backgroundColor=[UIColor whiteColor];
    
    pdfTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    pdfTableView.dataSource = self;
    pdfTableView.delegate = self;
    pdfTableView.tableHeaderView = [[UIView alloc] init];
    pdfTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:pdfTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"pdfTableView_cell";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    NSString *titleText = [self.titleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = titleText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZPDFReaderController *targetViewCtrl = [[ZPDFReaderController alloc] init];
    targetViewCtrl.titleText = self.titleArray[indexPath.row];
    targetViewCtrl.fileName =  self.fileArray[indexPath.row];
    [self.navigationController pushViewController:targetViewCtrl animated:YES];
}

-(NSArray*)titleArray
{
    if(!_titleArray)
    {
        _titleArray=@[
                      @"iOS 开发笔记——PDF的显示和浏览",
                      @"Objective-C和CoreFoundation对象相互转换的内存管理总结",
                      @"HTML5从入门到精通"];
    }
    return _titleArray;
}

-(NSArray*)fileArray
{
    if(!_fileArray)
    {
        _fileArray=@[@"001.pdf", @"002.pdf",  @"003.pdf"];
    }
    return _fileArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
