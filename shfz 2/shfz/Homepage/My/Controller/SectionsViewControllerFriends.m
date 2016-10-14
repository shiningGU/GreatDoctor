

#import "SectionsViewControllerFriends.h"
#import "NSDictionary-DeepMutableCopy.h"
#import "CustomCell.h"
#import "VerifyViewController.h"

#import "pinyin.h"

#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDKAddressBook.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/SMSSDK+ExtexdMethods.h>
#import <SMS_SDK/SMSSDK+AddressBookMethods.h>

@interface SectionsViewControllerFriends ()
{
    NSMutableArray* _testArray1;
    NSMutableArray* _testArray2;
    NSMutableArray* _addressBookData;
    NSMutableArray* _friendsData;
    NSMutableArray* _friendsData2;
    
    NSMutableArray* _other;
    
    NSString *_phone;
    NSString *_phone2;
    
    CGFloat _statusBarHeight;
    
    NSMutableArray *_titleArray;
    
    NSMutableDictionary *_titleDictionary;
}

@end

@implementation SectionsViewControllerFriends
@synthesize names;
@synthesize keys;
@synthesize table;
@synthesize search;
@synthesize allNames;

#pragma mark -
#pragma mark Custom Methods
- (void)resetSearch
{
    NSMutableDictionary *allNamesCopy = [self.allNames mutableDeepCopy];
    self.names = allNamesCopy;
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];

    [keyArray addObject:UITableViewIndexSearch];
    [keyArray addObjectsFromArray:[[self.allNames allKeys] 
                                   sortedArrayUsingSelector:@selector(compare:)]];
    //- (NSComparisonResult)compare:(NSNumber *)decimalNumber;
    //作用：比较两个字符串是否相同(不忽略大小写)
    //NSComparisonResult:NSOrderedAscending(升序)
    //                   NSOrderedSame(相同)
    //                   NSOrderedDescending(降序)
    self.keys = keyArray;
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self resetSearch];
    
    for (NSString *key in self.keys)
    {
        NSMutableArray *array = [names valueForKey:key];
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        for (NSString *name in array)
        {
            if ([name rangeOfString:searchTerm 
                            options:NSCaseInsensitiveSearch].location == NSNotFound)
                [toRemove addObject:name];
        }
        if ([array count] == [toRemove count])
            [sectionsToRemove addObject:key];
        [array removeObjectsInArray:toRemove];
    }
    [self.keys removeObjectsInArray:sectionsToRemove];
    [table reloadData];
}

-(void)clickLeftButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        _window.hidden = YES;
    }];
    
    //修改消息条数为0
    [SMSSDK setLatelyFriendsCount:0];

    if (_friendsBlock) {
        _friendsBlock(1,0);
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _friendsData = [NSMutableArray array];
        
        _friendsData2 = [NSMutableArray array];
    }
    return self;
}

-(void)setMyData:(NSArray*) array
{
    _friendsData = [NSMutableArray arrayWithArray:array];
}

-(void)setMyBlock:(SMSShowNewFriendsCountBlock)block
{
    _friendsBlock = block;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBACOLOR(0, 178, 255, 1.0);
    
    _statusBarHeight = 0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        _statusBarHeight = 20;
    }
    //创建一个导航栏
    [self initNavigationBar];
    
    
    //添加搜索框
    [self initSearchBar];
    
    //添加table
    [self initTableView];
    
    _other = [NSMutableArray array];
    _addressBookData = [SMSSDK addressBook];
    
//    NSLog(@"获取到了%zi条通讯录信息",_addressBookData.count);
//    
//    NSLog(@"获取到了%zi条好友信息",_friendsData.count);
    
    //双层循环 取出重复的通讯录信息
    [self initAdressBookData];
}

#pragma mark - initView
- (void)initNavigationBar {
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0+_statusBarHeight, self.view.frame.size.width, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
    //把导航栏集合添加入导航栏中，设置动画关闭
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [self.view addSubview:navigationBar];
    // 导航栏颜色
    navigationBar.barTintColor = RGBACOLOR(0, 178, 255, 1.0);
    // 导航栏标题颜色
    [navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    navigationBar.tintColor = [UIColor whiteColor];
}

- (void)initSearchBar {
    search=[[UISearchBar alloc] init];
    search.frame = CGRectMake(0, 44+_statusBarHeight, self.view.frame.size.width, 44);
    [self.view addSubview:search];
    search.delegate = self;
}

- (void)initTableView {
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 88 + _statusBarHeight, self.view.frame.size.width, self.view.bounds.size.height - (88 + _statusBarHeight)) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
}

- (void)initAdressBookData {
    for (int i = 0; i<_friendsData.count; i++) {
        NSDictionary* dict1 = [_friendsData objectAtIndex:i];
        NSString* phone1 = [dict1 objectForKey:@"phone"];
        NSString* name1 = [dict1 objectForKey:@"nickname"];
        for (int j = 0; j < _addressBookData.count; j++) {
            SMSSDKAddressBook* person1 = [_addressBookData objectAtIndex:j];
            for (int k = 0; k < person1.phonesEx.count; k++) {
                if ([phone1 isEqualToString:[person1.phonesEx objectAtIndex:k]])
                {
                    if (person1.name)
                    {
                        NSString* str1 = [NSString stringWithFormat:@"%@+%@",name1,person1.name];
                        NSString* str2 = [str1 stringByAppendingString:@"@"];
                        
                        [_friendsData2 addObject:str2];
                    }
                    else
                    {
                        //[_friendsData2 addObject:@""];
                    }
                    
                    [_addressBookData removeObjectAtIndex:j];
                }
                
            }
        }
    }
    //    NSLog(@"_friends1:%zi",_friendsData.count);
    //    NSLog(@"_friends2:%zi",_friendsData2.count);
    
    _titleArray = [NSMutableArray array];
    for (int i = 0; i < _addressBookData.count; i++) {
        SMSSDKAddressBook* person1 = [_addressBookData objectAtIndex:i];
        NSString* str1 = [NSString stringWithFormat:@"%@+%@",person1.name,person1.phones];
        NSString* str2 = [str1 stringByAppendingString:@"#"];
//        NSLog(@"%@",str2);
        [_titleArray addObject:person1.name];
        [_other addObject:str2];
    }
                 
    _titleDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *tempArr1 = [NSMutableArray array];
    NSMutableArray *tempArr2 = [NSMutableArray array];
    for (int j = 0; j < _titleArray.count; j++) {
        for (int i = 0; i < 26; i++) {
            NSString *firstLetter = [NSString stringWithFormat:@"%c",pinyinFirstLetter([[_titleArray objectAtIndex:j] characterAtIndex:0])];
            int asciiCode = [firstLetter characterAtIndex:0];
            if (asciiCode == 35 && [tempArr1 indexOfObject:[_titleArray objectAtIndex:j]] == NSNotFound) {
                [tempArr1 addObject:[_titleArray objectAtIndex:j]];
                [_titleDictionary setObject:tempArr1 forKey:@"#"];
                
            }else if (asciiCode == i + 97 && [tempArr1 indexOfObject:[_titleArray objectAtIndex:j]] == NSNotFound){
                
                [tempArr2 addObject:[_titleArray objectAtIndex:j]];
                [_titleDictionary setObject:[_titleArray objectAtIndex:j] forKey:firstLetter];
            }
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    _testArray1 = [NSMutableArray array];
    _testArray2 = [NSMutableArray array];
    
    if (_friendsData2.count > 0) {
        [dict setObject:_friendsData2 forKey:NSLocalizedString(@"hasjoined", nil)];
    }
    if (_other.count > 0) {
        [dict setObject:_other forKey:NSLocalizedString(@"toinvitefriends", nil)];
    }
    self.allNames = dict;
    
    [self resetSearch];
    [table reloadData];
}
#pragma mark Table View Data Source Methods
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [_titleDictionary allKeys];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [keys count];
    
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    if ([keys count] == 0)
        return 0;
    
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    return [nameSection count];
}

- (void)CustomCellBtnClick:(CustomCell *)cell
{
    [self.view endEditing:YES];
//    NSLog(@"cell的按钮被点击了-第%i组,第%i行", cell.section,cell.index);
    
    UIButton* btn = cell.btn;
//    NSLog(@"%@",btn.titleLabel.text);
    NSString* newStr = btn.titleLabel.text;
    
    if ([newStr isEqualToString:NSLocalizedString(@"addfriends", nil)])
    {
//        NSLog(@"添加好友");
//        NSLog(@"添加好友回调 用户自行处理");
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"addfriendstitle", nil) message:NSLocalizedString(@"addfriendsmsg", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    
    if ([newStr isEqualToString:NSLocalizedString(@"invitefriends", nil)])
    {
        _phone = cell.nameDesc;
        _phone2 = @"";
        if ([_phone2 length]>0)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                            message:NSLocalizedString(@"choosephonenumber", nil)
                                                           delegate:self
                                                  cancelButtonTitle:_phone
                                                  otherButtonTitles:_phone2, nil];
            [alert show];
        }
        else
        {
            [SMSSDK sendSMS:_phone?_phone:@"" AndMessage:NSLocalizedString(@"smsmessage", nil)];
        }
          
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        [SMSSDK sendSMS:_phone?_phone:@"" AndMessage:NSLocalizedString(@"smsmessage", nil)];
    }
    if (0 == buttonIndex)
    {
        [SMSSDK sendSMS:_phone?_phone:@"" AndMessage:NSLocalizedString(@"smsmessage", nil)];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    
    static NSString *CellWithIdentifier = @"CustomCellIdentifier";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil)
    {
        cell = [[CustomCell alloc] init];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSString* str1 = [nameSection objectAtIndex:indexPath.row];
    NSString* newStr1 = [str1 substringFromIndex:(str1.length-1)];
    
    NSRange range = [str1 rangeOfString:@"+"];
    NSString* str2 = [str1 substringFromIndex:range.location];
    NSString* phone = [str2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *cccc = [phone substringToIndex:[phone length] - 1];
    NSString* name = [str1 substringToIndex:range.location];
    
    if ([newStr1 isEqualToString:@"@"])
    {
        UIButton* btn = cell.btn;
        [btn setTitle:NSLocalizedString(@"addfriends", nil) forState:UIControlStateNormal];
        cell.nameDesc = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"phonecontacts", nil),cccc];
    }
    
    if ([newStr1 isEqualToString:@"#"])
    {
        UIButton* btn = cell.btn;
        [btn setTitle:NSLocalizedString(@"invitefriends", nil) forState:UIControlStateNormal];
        
        cell.nameDesc = [NSString stringWithFormat:@"%@",cccc];
        cell.nameDescLabel.hidden = YES;
    }
    
    cell.name = name;
    cell.index = (int)indexPath.row;
    cell.section = (int)[indexPath section];
    
    NSString* imagePath = [NSString stringWithFormat:@"friendPhoto.png"];
    cell.image = [UIImage imageNamed:imagePath];
    
    return cell;
}

#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}


- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if ([keys count] == 0)
        return nil;

    NSString *key = [keys objectAtIndex:section];
    if (key == UITableViewIndexSearch)
        return nil;
    
    return key;
}

#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [search resignFirstResponder];
    search.text = @"";
    isSearching = NO;
    [tableView reloadData];
    return indexPath;
}

- (NSInteger)tableView:(UITableView *)tableView 
sectionForSectionIndexTitle:(NSString *)title 
               atIndex:(NSInteger)index
{
    NSString *key = [keys objectAtIndex:index];
    if (key == UITableViewIndexSearch)
    {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    else return index;
}

#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
    [table reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar 
    textDidChange:(NSString *)searchTerm
{
    if ([searchTerm length] == 0)
    {
        [self resetSearch];
        [table reloadData];
        return;
    }
    
    [self handleSearchForTerm:searchTerm];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearching = NO;
    search.text = @"";

    [self resetSearch];
    [table reloadData];
    
    [searchBar resignFirstResponder];
}

@end
