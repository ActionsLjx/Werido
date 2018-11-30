//
//  firstOpenVC.m
//  Weirdo
//
//  Created by _LJX on 2018/8/26.
//  Copyright © 2018年 _Ljx. All rights reserved.
//

#import "firstOpenVC.h"
#import "HomeController.h"
#import "musicPlayerSingle.h"
#import "LocalNotification.h"
@interface firstOpenVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;

@end

@implementation firstOpenVC


-(void)initUI{
    self.scrollView.contentInsetAdjustmentBehavior = NO;
    self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.scrollView.bounces = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.delegate = self;

    NSArray *array=[NSArray arrayWithObjects:@"1",@"2", nil];
    for (int i=0; i<array.count; i++) {
        UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollView.frame.size.width,0,_scrollView.frame.size.width,_scrollView.frame.size.height)];
        [view setImage:[UIImage imageNamed:@"moon2.jpg"]];
        view.userInteractionEnabled = YES;
        if( i == 0){
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 375, 50)];
            lab.center = self.view.center;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = @"谢谢你 打开这个app";
            lab.textColor = [UIColor whiteColor];
            [view addSubview:lab];
        }
        if (i == array.count-1) {
            UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(135, 400, 100, 50)];
            [nextBtn setTitle:@"进入主页" forState:UIControlStateNormal];
            [nextBtn setBackgroundImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
            [view addSubview:nextBtn];
            [nextBtn addTarget:self action:@selector(nextController) forControlEvents:UIControlEventTouchUpInside];
        }
        [_scrollView addSubview:view];
    }
    _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width*2, _scrollView.frame.size.height);

    //init pageControll
    _pageControll.backgroundColor=[UIColor clearColor];
    _pageControll.numberOfPages=array.count;
    _pageControll.currentPage=0;

}


-(void)nextController{
    NSLog(@"点击");
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"rootController"];
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma ScrollView
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{

    int index=fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
    _pageControll.currentPage=index;
}

-(BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [[musicPlayerSingle shareInstance] musicPlay];
    [LocalNotification createLocalizedUserNotificationWithTitle:@"加油!" WithSubtitle:nil WithBody:@"好好学习" WithBadge:0 WithAfterTime:15];
}




@end
