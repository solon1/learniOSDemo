//
//  SNSearchViewController.m
//  StoreSearch
//
//  Created by solon on 16/5/28.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "SNSearchViewController.h"
#import "SNSearchResult.h"

#define storeSearchCellId @"storeSearchCellId"

@interface SNSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SNSearchViewController{
    
    NSMutableArray *_fakeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainView];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupMainView
{
 
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:storeSearchCellId];

    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_fakeArray == nil) {
        return 0;
    }else if(_fakeArray.count == 0){//当没有数据的时候提示用户没有找到
        return 1;
    }else {
        return _fakeArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeSearchCellId];

    
    if (_fakeArray.count) {
        
        SNSearchResult *searchResult = _fakeArray[indexPath.row];
        cell.textLabel.text = searchResult.name;
        cell.detailTextLabel.text = searchResult.artistName;
    }else {
        cell.textLabel.text = @"not found";
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_fakeArray.count == 0) {
        return nil;
    }else {
        return indexPath;
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    _fakeArray = [NSMutableArray arrayWithCapacity:10];
    
    if (![searchBar.text isEqualToString:@"just"]) {
        for (int i = 0; i < 4; i++) {
            SNSearchResult *searchResult = [[SNSearchResult alloc]init];
            searchResult.name = [NSString stringWithFormat:@"Fake result %zd",i];
            searchResult.artistName = searchBar.text;
            [_fakeArray addObject:searchResult];
        }
        
    }
    
    [self.tableView reloadData];
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

@end
