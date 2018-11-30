//
//  HomeController.m
//  Weirdo
//
//  Created by _LJX on 2018/9/7.
//  Copyright © 2018年 _Ljx. All rights reserved.
//

#import "HomeController.h"
#import "MusicController.h"
#import "musicPlayerSingle.h"
#import "LocalNotification.h"
#import "NSBundle+JXExtension.h"
#import <Lottie/Lottie.h>
#import "MBProgressHUD+JXExtension.h"
#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height

@interface HomeController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIBarButtonItem *rightBtn;
@property(nonatomic,strong)UIImageView *headPortrait;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property(nonatomic,strong)UILabel *name;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UISwitch *switchBtn;
@property(nonatomic,strong)UISwitch *autoPlaySongs;
@property(nonatomic,strong)MusicController *vc;
@end

@implementation HomeController

-(UIBarButtonItem *)rightBtn{
    if (_rightBtn == nil) {
        
        UIImage *rightImage = [[UIImage imageNamed:@"音乐-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _rightBtn = [[UIBarButtonItem alloc]initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(toMusicController)];
        _rightBtn.tintColor = [UIColor clearColor];
        self.navigationItem.rightBarButtonItem = _rightBtn;
        
    }
    return _rightBtn;
}


- (UILabel *)name{
    if (_name == nil) {
         CGFloat X = (screenW-110)/2;
        _name = [[UILabel alloc]initWithFrame:CGRectMake(X,155, 110, 40)];
        _name.text  = @"Weirdo";
        _name.font = [UIFont boldSystemFontOfSize:20];
        _name.textAlignment = NSTextAlignmentCenter;
        _name.textColor = [UIColor whiteColor];
        [self.view addSubview:_name];
    }
    return  _name;
}

-(void)toMusicController{
   
    [self.navigationController pushViewController:_vc animated:YES];
}

-(UIImageView *)headPortrait{
    if (_headPortrait == nil) {
        CGFloat W = 110;
        CGFloat X = (screenW-110)/2;
        CGFloat Y = 40;
        _headPortrait = [[UIImageView alloc]initWithFrame:CGRectMake(X, Y,W, W)];
        [_headPortrait setImage:[UIImage imageNamed:@"头像.jpg"]];
        _headPortrait.layer.cornerRadius = _headPortrait.frame.size.width/2;
        _headPortrait.clipsToBounds = YES;
        _headPortrait.layer.borderWidth = 3.0f;
        _headPortrait.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.background addSubview:_headPortrait];
    }
    return _headPortrait;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 1;
    if (section ==0) {
        row = 4;
    }
    if (section ==1) {
        row = 1;
    }
    return row;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    static NSString *identifity = @"identifity";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifity];
    if (indexPath.section ==0) {
    switch (row) {
        case 0:
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"id1"];
                cell.textLabel.text =NSLocalizedString(@"音乐", @"Music");
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case 1:{
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"id1"];
            cell.textLabel.text = NSLocalizedString(@"自动播放音乐", @"自动播放音乐");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _autoPlaySongs = [[UISwitch alloc]initWithFrame:CGRectZero];
            _autoPlaySongs.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoPlaySongs"];
            [_autoPlaySongs addTarget:self action:@selector(changePlaySongs) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = _autoPlaySongs;
        }
            break;
        case 2:{
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"id1"];
            cell.textLabel.text = NSLocalizedString(@"提醒", @"提醒");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _switchBtn = [[UISwitch alloc]initWithFrame:CGRectZero];
            _switchBtn.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenNotification"];
            [_switchBtn addTarget:self action:@selector(changeNotice) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = _switchBtn;
        }
            break;
        case 3:{
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"id1"];
            cell.textLabel.text = NSLocalizedString(@"语言", @"语言");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        default:
            break;
    }
    }
    if (indexPath.section ==1) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"id1"];
        cell.textLabel.text =  NSLocalizedString(@"关于", @"关于");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0&&indexPath.row == 0) {
        [self.navigationController pushViewController:_vc animated:YES];
    }
    /*
     该修改语言方法仅在viewDidLoade中加载的界面有效
     */
    if (indexPath.section == 0&&indexPath.row == 3) {
        NSArray *langArr1 = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
        if([langArr1[0] isEqualToString:@"en"]){
            NSLog(@"设置中文");
            NSArray *lans = @[@"zh-Hans"];
            [NSBundle setLanguage:@"zh-Hans"];
            [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
            HomeController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HomeController"];
            [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
            [UIApplication sharedApplication].keyWindow.rootViewController = VC;
            [MBProgressHUD showSuccess:@"修改成功"];
        }
        else{
            NSLog(@"设置英文");
            NSArray *lans = @[@"en"];
             [NSBundle setLanguage:@"en"];
            [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            HomeController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HomeController"];
            [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
            [UIApplication sharedApplication].keyWindow.rootViewController = VC;
             [MBProgressHUD showSuccess:@"修改成功"];
        }
    }
    if (indexPath.section == 1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"微博" message:@"@我又何苦太苛求" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:^{
            LOTAnimationView *animation = [LOTAnimationView animationNamed:@"heart" inBundle:[NSBundle mainBundle]];
            animation.center = self.view.center;
            [self.view addSubview:animation];
            [animation playWithCompletion:^(BOOL animationFinished) {
                [animation removeFromSuperview];
            }];
        }];
    }
}

-(void)changePlaySongs{
   [[NSUserDefaults standardUserDefaults]setBool:_autoPlaySongs.on forKey:@"isAutoPlaySongs"];
}

-(void)changeNotice{
    [[NSUserDefaults standardUserDefaults]setBool:_switchBtn.on forKey:@"isOpenNotification"];
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isOpenNotification"]){
        [LocalNotification createDateNotif];
    }else{
        [[UNUserNotificationCenter currentNotificationCenter]removeAllDeliveredNotifications];
    }
}


-(void)initControllerView{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self rightBtn];
    [self headPortrait];
    [self name];
    [self.tableView setScrollEnabled:NO];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     _vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MusicController"];
    [self initControllerView];
    [[UNUserNotificationCenter currentNotificationCenter]removeAllDeliveredNotifications];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isAutoPlaySongs"]) {
        NSLog(@"自动播放音乐");
        [[musicPlayerSingle shareInstance] musicPlay];
    }
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isOpenNotification"]){
        [LocalNotification createDateNotif];
    }
    [self.tableView reloadData];
}






@end
