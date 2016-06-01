//
//  SNSearchViewController.m
//  StoreSearch
//
//  Created by solon on 16/5/28.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "SNSearchViewController.h"
#import "SNSearchResult.h"
#import "SNSearchResultCell.h"
#import "SNNothingFoundCell.h"


static NSString * const SNSearchResultCellIdentifier = @"SNSearchResultCell";
static NSString * const SNNothingFoundCellIdentifier = @"SNNothingFoundCell";

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
 
    [self.searchBar becomeFirstResponder];
//    [self.tableView registerClass:[SNSearchResultCell class] forCellReuseIdentifier:storeSearchCellId];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SNSearchResultCell class]) bundle:nil] forCellReuseIdentifier:SNSearchResultCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:SNNothingFoundCellIdentifier bundle:nil] forCellReuseIdentifier:SNNothingFoundCellIdentifier];
    
    self.tableView.rowHeight = 80.0f;

    
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

    
    if (_fakeArray.count) {
        
        SNSearchResultCell *searchResultCell = [tableView dequeueReusableCellWithIdentifier:SNSearchResultCellIdentifier forIndexPath:indexPath];
        
        SNSearchResult *searchResult = _fakeArray[indexPath.row];
        searchResultCell.nameLabel.text = searchResult.name;
        searchResultCell.artistNameLabel.text = searchResult.artistName;
        
        return searchResultCell;

    }else {
        SNNothingFoundCell *nothingFoundCell = [tableView dequeueReusableCellWithIdentifier:SNNothingFoundCellIdentifier forIndexPath:indexPath];
        return nothingFoundCell;
    }
    
    
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
//    [searchBar resignFirstResponder];
//    
//    if (![searchBar.text isEqualToString:@"just"]) {
//        for (int i = 0; i < 4; i++) {
//            SNSearchResult *searchResult = [[SNSearchResult alloc]init];
//            searchResult.name = [NSString stringWithFormat:@"Fake result %zd",i];
//            searchResult.artistName = searchBar.text;
//            [_fakeArray addObject:searchResult];
//        }
//
//    }
    
    if (searchBar.text.length > 0) {
        [searchBar resignFirstResponder];
        _fakeArray = [NSMutableArray arrayWithCapacity:10];
//        NSURL *url = [NSURL URLWithString:searchBar.text];
        NSURL *url = [self urlWithSearchText:searchBar.text];
        
        
    }
    
    [self.tableView reloadData];
}


- (NSURL *)urlWithSearchText:(NSString *)searchText
{
    NSString *urlString = [NSString stringWithFormat: @"http://itunes.apple.com/search?term=%@", searchText];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

@end
