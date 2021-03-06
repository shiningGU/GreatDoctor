

#import <UIKit/UIKit.h>
#import "CustomCell.h"

#import <SMS_SDK/SMSSDKResultHanderDef.h>

@interface SectionsViewControllerFriends : UIViewController
<UITableViewDataSource,
UITableViewDelegate,
CustomCellDelegate,
UISearchBarDelegate>
{
    UITableView *table;
    UISearchBar *search;
    NSDictionary *allNames;
    NSMutableDictionary *names;
    NSMutableArray  *keys;    
    
    BOOL    isSearching;
}

@property (nonatomic, strong)  UITableView *table;
@property (nonatomic, strong)  UISearchBar *search;
@property (nonatomic, strong) NSDictionary *allNames;
@property (nonatomic, strong) NSMutableDictionary *names;
@property (nonatomic, strong) NSMutableArray *keys;

@property (nonatomic,strong) UIWindow* window;
@property (nonatomic,strong) SMSShowNewFriendsCountBlock friendsBlock;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;
- (void)setMyData:(NSMutableArray*) array;
- (void)setMyBlock:(SMSShowNewFriendsCountBlock)block;

@end

