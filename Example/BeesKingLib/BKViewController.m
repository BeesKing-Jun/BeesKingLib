//
//  BKViewController.m
//  BeesKingLib
//
//  Created by BeesKing-Jun on 03/05/2020.
//  Copyright (c) 2020 BeesKing-Jun. All rights reserved.
//

#import "BKViewController.h"
#import <BKRequestManager.h>
#import <BKBaseRequest.h>

@interface BKViewController ()

@end

@implementation BKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testRequest];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)testRequest
{
    BKBaseRequest *request = [[BKBaseRequest alloc] initWithBaseURL:@"http://www.baidu.com" URLString:@"/testURL" params:@{@"name":@"value"}];
    [[BKRequestManager shareManager] sendRequestWithRequest:request successed:^(id responseObject) {
        
    } failed:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
