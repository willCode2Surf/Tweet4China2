//
//  HSUBaseViewController.m
//  Tweet4China
//
//  Created by Jason Hsu on 3/3/13.
//  Copyright (c) 2013 Jason Hsu <support@tuoxie.me>. All rights reserved.
//

#import "HSUBaseViewController.h"
#import "HSUTexturedView.h"
#import "HSUStatusCell.h"
#import "HSUBaseDataSource.h"
#import "HSUStatusViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HSUBaseViewController ()

@end

@implementation HSUBaseViewController
{
    UITableView *tableView;
}

#pragma mark - Liftstyle
- (id)init
{
    self = [super init];
    if (self) {
        self.tableViewFrame = RM(0, 10, [HSUCommonTools winWidth], [HSUCommonTools winHeight] - 10);
        self.dataSourceClass = [HSUBaseDataSource class];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[self.dataSourceClass alloc] init];
    self.dataSource.delegate = self;
    
    tableView = [[UITableView alloc] init];
    tableView.frame = self.tableViewFrame;
    [tableView registerClass:[HSUStatusCell class] forCellReuseIdentifier:@"Status"];
    tableView.dataSource = self.dataSource;
    [self.view addSubview:tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *texture = [UIImage imageNamed:@"bg_texture"];
    UIView *background = [[HSUTexturedView alloc] initWithFrame:self.view.bounds texture:texture];
    [self.view addSubview:background];
}


#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = [self.dataSource dataAtIndex:indexPath.row];
    NSString *dataType = data[@"data_type"];
    Class cellClass = [self cellClassForDataType:dataType];
    return [cellClass heightForData:data];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = [self.dataSource dataAtIndex:indexPath.row];
    if ([data[@"data_type"] isEqualToString:@"LoadMore"]) {
        [self.dataSource loadMore];
    }
}

- (Class)cellClassForDataType:(NSString *)dataType
{
    return NSClassFromString([NSString stringWithFormat:@"HSU%@Cell", dataType]);
}

- (void)dataSource:(HSUBaseDataSource *)dataSource didFinishUpdateWithError:(NSError *)error
{
}

#pragma mark - Actions

@end
