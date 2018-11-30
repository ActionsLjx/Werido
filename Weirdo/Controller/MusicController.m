//
//  MusicController.m
//  Weirdo
//
//  Created by _LJX on 2018/9/9.
//  Copyright © 2018年 _Ljx. All rights reserved.
//

#import "MusicController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIImageView+JXExtension.h"
#import "musicPlayerSingle.h"
#import "LrcModel.h"
#import "lrcCell.h"
@interface MusicController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *playerControlView;
@property(nonatomic, strong)UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UISlider *sliderProgress;
@property (weak, nonatomic) IBOutlet UILabel *currentPlayTime;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UIButton *beforeBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic)UIImageView *albumImg;
@property (strong,nonatomic)NSTimer *timer1;
@property (strong,nonatomic)NSTimer *timer2;
@property (strong,nonatomic)NSArray *lrcList;
@end

@implementation MusicController



- (IBAction)playSongsAction:(id)sender {
    [[musicPlayerSingle shareInstance] musicPlay];
    [self playBtnImageChange];
}

- (IBAction)beforeSongsAction:(id)sender {

    
    [[musicPlayerSingle shareInstance] musicBefore];
    [self updateMusicUI];
}

- (IBAction)nextSongsActon:(id)sender {
    [[musicPlayerSingle shareInstance] musicNext];
    [self updateMusicUI];
}

- (IBAction)changeProgressAction:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
    [musicPlayerSingle shareInstance].player.currentTime = slider.value;
}

-(void)updateImage{
    NSInteger songID =[musicPlayerSingle shareInstance].songID;
    [_albumImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"唱片%lu.jpg",songID+1]]];
    _background.image = [UIImage imageNamed:[NSString stringWithFormat:@"唱片%lu.jpg",songID+1]];
}


-(void)initScrollView{
    self.scrollView.contentInsetAdjustmentBehavior = NO;
    self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.scrollView.bounces = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:_tableView];
    
    
    CGFloat height = self.view.frame.size.height-self.playerControlView.frame.size.height-60;
    _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width*2, height);
    
    _pageControl.backgroundColor=[UIColor clearColor];
    _pageControl.numberOfPages=2;
    _pageControl.currentPage=0;
}

-(UIImageView *)albumImg{
    if (_albumImg == nil) {
        CGFloat x = self.view.frame.size.width/2 -125;
        CGFloat y = self.scrollView.frame.size.height/2-125;
        _albumImg = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, 250, 250)];
        [self.scrollView addSubview:_albumImg];
        [_albumImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"唱片%lu.jpg",[musicPlayerSingle shareInstance].songID+1]]];
        _albumImg.layer.cornerRadius = _albumImg.frame.size.width/2;
        _albumImg.clipsToBounds = YES;
        _albumImg.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return  _albumImg;
}


-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, 400) style:UITableViewStylePlain];
//        [_tableView setHidden:YES];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.allowsSelection = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.userInteractionEnabled = YES;
    }
    return _tableView;
}

-(void)initControllView{
    
    [self lrcList];
    [self tableView];
    [self initScrollView];
    //标题
    NSInteger songID = [musicPlayerSingle shareInstance].songID;
    self.navigationItem.title = [musicPlayerSingle shareInstance].songsList[songID];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //背景
    _background.image = [UIImage imageNamed:[NSString stringWithFormat:@"唱片%lu.jpg",songID+1]];
    _background.contentMode = UIViewContentModeScaleAspectFill;
    _background.userInteractionEnabled = YES;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, _background.frame.size.width, _background.frame.size.height);
    [_background addSubview:effectView];
    
    //滑块
    UIImage *image = [UIImage imageNamed:@"圆点"];
    [_sliderProgress setThumbImage:image forState:UIControlStateNormal];
    
    //播放按钮状态
    [self playBtnImageChange];
    
    //添加唱片
    [self albumImg];
    [_albumImg startRotating];
    
}

-(void)createTimer{
    _timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimeChange) userInfo:nil repeats:YES];
    _timer2 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(moveTableViewCell) userInfo:nil repeats:YES];
}

-(void)cancleTimer{
    [_timer1 invalidate];
    [_timer2 invalidate];
}

-(void)playBtnImageChange{
    if ([musicPlayerSingle shareInstance].player.isPlaying) {
        [self cancleTimer];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    }else{
        [self createTimer];
           [_playBtn setBackgroundImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    }
}

-(void)updateMusicUI{
    
    _lrcList = nil;
    [self lrcList];
    [self updateImage];
    [self.tableView reloadData];
    NSInteger songID = [musicPlayerSingle shareInstance].songID;
    self.navigationItem.title = [musicPlayerSingle shareInstance].songsList[songID];
    
    _sliderProgress.continuous = YES;
    _sliderProgress.maximumValue = [musicPlayerSingle shareInstance].player.duration;
    _sliderProgress.minimumValue = 0;
    _sliderProgress.value = 0;
    
    NSTimeInterval time = [musicPlayerSingle shareInstance].player.duration;
    NSString *string = [NSString stringWithFormat:@"%02li:%02li",
                        lround(floor(time / 60.)) % 60,
                        lround(floor(time)) % 60];
    [_totalTime setText:string];
    
    [self createTimer];
}

-(void)TimeChange{
    NSTimeInterval time = [musicPlayerSingle shareInstance].player.currentTime;
    NSTimeInterval timeA = [musicPlayerSingle shareInstance].player.duration;
    double a = 1;
    NSString *string = [NSString stringWithFormat:@"%02li:%02li",
                        lround(floor(time / 60.)) % 60,
                        lround(floor(time)) % 60];
    _currentPlayTime.text = string;
    _sliderProgress.value = [musicPlayerSingle shareInstance].player.currentTime;
    if(time+a>timeA){
        [[musicPlayerSingle shareInstance] musicNext];
        [self updateMusicUI];
    }
}

#pragma mark ----scrollview

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    int index=fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
    _pageControl.currentPage=index;
}

-(BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
}

#pragma mark ----tableview


-(NSArray *)lrcList{
    if(_lrcList ==nil){
        [musicPlayerSingle shareInstance].number = 0;
        NSMutableArray *two = [[NSMutableArray alloc]init];
        NSInteger songID = [musicPlayerSingle shareInstance].songID;
        NSString *path = [[NSBundle mainBundle]pathForResource:[musicPlayerSingle shareInstance].songsList[songID] ofType:@"lrc"];
            NSString *str=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSArray *array = [str componentsSeparatedByString:@"\n"];
            int count = 0;
            
            for (NSArray *dic in array) {
                if(count<5){}
                else{
                    LrcModel *mode =[[LrcModel alloc]initWithDict:dic];
                    [two addObject:mode];
                }
                
                count++;
            }
            _lrcList  = two;
        
        
    }
    return _lrcList;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _lrcList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LrcModel *mode = _lrcList[indexPath.row];
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    //    lrcCell *cell =[tableView dequeueReusableCellWithIdentifier:
    //                            TableSampleIdentifier];
    lrcCell *cell = [[NSBundle mainBundle]loadNibNamed:@"lrcCell" owner:nil options:nil].firstObject;
    if (cell == nil) {
        cell = [[lrcCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:TableSampleIdentifier];
        
    }
    cell.textLabel.textAlignment =NSTextAlignmentCenter;
    cell.Lable.text= mode.sentence;
    cell.time = mode.time;
    return cell;
}




-(void)moveTableViewCell{
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:[musicPlayerSingle shareInstance].number inSection:0];
    LrcModel *mode = _lrcList[[musicPlayerSingle shareInstance].number];
    if(_lrcList.count>[musicPlayerSingle shareInstance].number){
        
        if([musicPlayerSingle shareInstance].player.currentTime>=mode.time){
            
            [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [musicPlayerSingle shareInstance].number = [musicPlayerSingle shareInstance].number+1;
            }
        }
        if([musicPlayerSingle shareInstance].player.currentTime+10<mode.time&&[musicPlayerSingle shareInstance].number>1){
           
            [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [musicPlayerSingle shareInstance].number = [musicPlayerSingle shareInstance].number-1;
        
        }
     
    
}


#pragma mark -----界面加载
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![musicPlayerSingle shareInstance].player.isPlaying) {
         [[musicPlayerSingle shareInstance] musicPlay];
    }
    [self initControllView];
    [self updateMusicUI];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self cancleTimer];
}



@end
