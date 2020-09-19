//
//  ViewController.m
//  YHLagMonitor_Example
//
//  Created by Vanha on 2019/12/18.
//  Copyright © 2020 wanwan. All rights reserved.
//

#import "ViewController.h"
#import "YHLagMonitor.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
/**  */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView reloadData];
    
    [[YHLagMonitor shareInstance] beginMonitor];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (int i = 1; i < 1000; i++) {
        NSLog(@"你好！");
    }
}

@end
