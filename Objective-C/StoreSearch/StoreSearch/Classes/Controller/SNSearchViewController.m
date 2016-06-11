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
#import "SNLoadingCell.h"
#import "AFNetworking.h"


static NSString * const SNSearchResultCellIdentifier = @"SNSearchResultCell";
static NSString * const SNNothingFoundCellIdentifier = @"SNNothingFoundCell";
static NSString * const SNLoadingCellIdentifier = @"SNLoadingCell";


@interface SNSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SNSearchViewController{
    
    NSMutableArray *_searchResults;
    BOOL _isLoading;
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
    
    [self.tableView registerNib:[UINib nibWithNibName:SNLoadingCellIdentifier bundle:nil] forCellReuseIdentifier:SNLoadingCellIdentifier];
    
    self.tableView.rowHeight = 80.0f;

    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isLoading) {
        return 1;
    }else if (_searchResults == nil) {
        return 0;
    }else if(_searchResults.count == 0){//当没有数据的时候提示用户没有找到
        return 1;
    }else {
        return _searchResults.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_isLoading) {
    
        SNLoadingCell *loadingCell = [tableView dequeueReusableCellWithIdentifier:SNLoadingCellIdentifier];
        
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[loadingCell viewWithTag:100];
        [spinner startAnimating];
        
        return loadingCell;
        
    }else if (_searchResults.count) {
        
        SNSearchResultCell *searchResultCell = [tableView dequeueReusableCellWithIdentifier:SNSearchResultCellIdentifier forIndexPath:indexPath];
        
        SNSearchResult *searchResult = _searchResults[indexPath.row];
        
        [searchResultCell configureForSearchResult:searchResult];
        
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
    if (_searchResults.count == 0 || _isLoading) {
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
//            [_searchResults addObject:searchResult];
//        }
//
//    }
    
    if (searchBar.text.length > 0) {
        [searchBar resignFirstResponder];
        _isLoading = YES;
        [self.tableView reloadData];
        
        _searchResults = [NSMutableArray arrayWithCapacity:10];
//        NSURL *url = [NSURL URLWithString:searchBar.text];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(queue, ^{
            NSURL *url = [self urlWithSearchText:searchBar.text];
            
            NSString *json = [self performStoreRequestWithURL:url];
            
            if (json == nil) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showNetworkError];
                });
                return;
            }
            NSDictionary *resultDictionary = [self parseJSON:json];
            
            if (resultDictionary == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showNetworkError];
                });
                return;
            }
            
            [self parseDictionary:resultDictionary];
            //        NSLog(@"url --- %@",resultDictionary);
            [_searchResults sortUsingSelector:@selector(compareName:)];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                        _isLoading = NO;
                        [self.tableView reloadData];
            });
        });
        
        
    }
    
}

#pragma mark - parseDictionary

- (void)parseDictionary:(NSDictionary *)dictionary
{
    NSArray *results = [dictionary objectForKey:@"results"];
    
    if (results == nil) {
        NSLog(@"expect results array");
        return;
    }
    
    for (NSDictionary *resultDic in results) {
        
        SNSearchResult *searchResult = [[SNSearchResult alloc]init];
        NSLog(@"wraped Type:%@  kind:%@",resultDic[@"wrapperType"],resultDic[@"kind"]);
        
        NSString *wrapperType = resultDic[@"wrapperType"];
        
        if ([wrapperType isEqualToString:@"track"]) {
            
            searchResult = [self parseTrack:resultDic];
            
        }else if ([wrapperType isEqualToString:@"audiobook" ]){
            searchResult = [self parseAudioBook:resultDic];
        }else if ([wrapperType isEqualToString:@"software" ]){
            searchResult = [self parseSoftware:resultDic];
        }else if ([wrapperType isEqualToString:@"ebook" ]){
            searchResult = [self parseEBook:resultDic];
        }
        
        if (searchResult != nil) {
            [_searchResults addObject:searchResult];
        }
    }
}

#pragma mark - 字典转模型
- (SNSearchResult *)parseTrack:(NSDictionary *)dictionary
{
    SNSearchResult *searchResult = [[SNSearchResult alloc] init];
    
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"trackPrice"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    
    return searchResult;
}

- (SNSearchResult *)parseAudioBook:(NSDictionary *)dictionary {
    
    SNSearchResult *searchResult = [[SNSearchResult alloc] init];
    searchResult.name = dictionary[@"collectionName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"collectionViewUrl"];
    searchResult.kind = @"audiobook";
    searchResult.price = dictionary[@"collectionPrice"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    
    return searchResult;
    
}
- (SNSearchResult *)parseSoftware:(NSDictionary *)dictionary {
    
    SNSearchResult *searchResult = [[SNSearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"price"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    
    return searchResult;
}
- (SNSearchResult *)parseEBook:(NSDictionary *)dictionary {
    
    SNSearchResult *searchResult = [[SNSearchResult alloc] init]; searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"price"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = [(NSArray *)dictionary[@"genres"] componentsJoinedByString:@", "];
                        
                          
    return searchResult;
                          
}

#pragma mark - 弹框网络请求错误
- (void)showNetworkError
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Whoops" message:@"There was an error message from iTunes Store,Please try again" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - parseJSON

- (NSDictionary *)parseJSON:(NSString *)json
{
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    id resultObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (![resultObject isKindOfClass:[NSDictionary class]]) {
        NSLog(@"json error: expected Dictionary error - %@",error.description);
        return nil;
    }
    
    return resultObject;

}

#pragma mark - 根据url请求数据转换为字符串
- (NSString *)performStoreRequestWithURL:(NSURL *)url
{
    NSError *error;
    NSString *resultString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    if (!resultString) {
        NSLog(@"error - %@",error.description);
        return nil;
    }
        

    return resultString;

    
}

#pragma mark - 将搜索内容转为url
- (NSURL *)urlWithSearchText:(NSString *)searchText
{
//    NSString *escapedSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSCharacterSet *charSet = [NSCharacterSet URLPathAllowedCharacterSet];
    NSString *escapedSearchText = [searchText stringByAddingPercentEncodingWithAllowedCharacters:charSet];
    
    
    NSString *urlString = [NSString stringWithFormat: @"http://itunes.apple.com/search?term=%@", escapedSearchText];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

@end
