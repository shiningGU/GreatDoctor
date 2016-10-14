//
//  DKModalImageBrowser.m
//  shfz
//
//  Created by shanghaifuzhong on 15/8/6.
//  Copyright (c) 2015年 shanghaifuzhong. All rights reserved.
//

#import "DKModalImageBrowser.h"
#import "DKImageBrowser.h"

@interface DKModalImageBrowser ()

@end

@implementation DKModalImageBrowser

- (id)init {
    self.imageBrowser = [[DKImageBrowser alloc] init];
    
    if (self = [super initWithRootViewController:self.imageBrowser]) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DKModalActionDone)];
        
        self.imageBrowser.navigationItem.rightBarButtonItem = doneButton;
        self.imageBrowser.navigationController.navigationBar.barTintColor = RGBACOLOR(0, 178, 255, 1.0);
        self.imageBrowser.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.imageBrowser.title = self.title;
}


- (void)DKModalActionDone {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
