//
//  ViewController.m
//  ePubSample
//
//  Created by Nuevalgo on 29/04/14.
//  Copyright (c) 2014 Nuevalgo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    bookView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 20, 320, self.view.frame.size.height)];
//    bookView.scrollView.scrollEnabled=NO;
//    bookView.scrollView.bounces=NO;
//    [self.view addSubview:bookView];
//    
//    UISwipeGestureRecognizer* rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextPage)] ;
//	[rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
//	
//	UISwipeGestureRecognizer* leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevPage)];
//	[leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
//	
//	[bookView addGestureRecognizer:rightSwipeRecognizer];
//	[bookView addGestureRecognizer:leftSwipeRecognizer];
    
}
-(void)viewDidAppear:(BOOL)animated{
    EpubReaderViewController *epubReaderViewController=[[EpubReaderViewController alloc] initWithNibName:@"EpubReaderViewController"
                                                                                                  bundle:nil];
    
    epubReaderViewController._strFileName=@"stoker-dracula";
	[epubReaderViewController setTitlename:@"ePub Reader"];
	[self presentViewController:epubReaderViewController animated:NO completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
