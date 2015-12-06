//
//  ViewController.m
//  HttpDemo_1520
//
//  Created by 张诚 on 15/7/20.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSURLConnection*_connection;
    
    UITableView*_tableView;

}
//需要进行保存数据，由于数据比较大，有时候我们需要反复进行追加才可以，比如下载电影，网络一次传输数据只有4k或者8k，需要连续请求才可以获得完整数据
@property(nonatomic,strong)NSMutableData*data;
//保存tableView数据源
@property(nonatomic,strong)NSMutableArray*dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建tableView
    [self createTableView];
    
    [self createRequest];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark 创建tableView
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}
#pragma mark  tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
//读取数据源
//    NSDictionary*dic=self.dataArray[indexPath.row];
//    cell.textLabel.text=dic[@"wbody"];
    
    cell.textLabel.text=self.dataArray[indexPath.row][@"wbody"];
    cell.textLabel.numberOfLines=0;
    cell.textLabel.font=[UIFont systemFontOfSize:8];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)createRequest{
/*
之前我们学习了同步数据请求，同步数据请求，最大的缺点是当数据没有请求完成时候，程序进入假死状态，我们需要解决这个问题，所以就有了异步数据请求
在iOS开发过程中，苹果本身提供API极大简化了这个过程，和安卓不同的是安卓的网络请求需要自己来开辟线程进行管理，而苹果把线程包装在我们的方法中，在我们学习完初级网络时候，根本感觉不到线程作用
什么是异步
 不卡主线程，不会导致界面假死，类似我在这里讲课，你们在听课，这是一个同步的过程，我现在渴了，需要喝水，而没有水，我如果自己去打水，你们就应该等待我回来，为了解决这个问题，我们采用召唤小弟方式，我召唤出来一个人，给我去打水，我继续讲课，但是小弟现在在跑去给我打水，打水总要有回来的时候，回来以后，那么你们就看我喝水，当然，也有例外，我的水杯是金的，小弟拿着我的水杯跑路了
 
 我发起网络请求，小弟进行携带数据返回，最后通过代理告知我数据请求完成的一个过程
 */

//    //创建NSURL
//    NSURL*url=[NSURL URLWithString:@"http://223.6.252.214/weibofun/weibo_list.php?apiver=10500&category=weibo_jokes&page=0&page_size=30&max_timestamp=-1"];
//    //建立请求头
//    NSURLRequest*request=[NSURLRequest requestWithURL:url];
//    //建立链接
//    _connection=[NSURLConnection connectionWithRequest:request delegate:self];

    
    //合并后的方法
    _connection=[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://223.6.252.214/weibofun/weibo_list.php?apiver=10500&category=weibo_jokes&page=0&page_size=30&max_timestamp=-1"]] delegate:self];
    
    //如果数据请求中间你需要取消这个请求 cancel方法
//    [_connection cancel];
}
#pragma mark 4个代理方法
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"开始接收数据，在这里进行data初始化");
    self.data=[NSMutableData data];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"数据的持续返回，当请求数据过大时候，这里会一直追加，到接收完成");
    [self.data appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"请求完成 需要开始数据解析");
    
    //解析数据
    NSDictionary*dic=[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@",dic);
    
    
    //进行数据初始化
//    self.dataArray=[NSMutableArray array];
//    self.dataArray=[[NSMutableArray alloc]init];
//    self.dataArray=[NSMutableArray arrayWithCapacity:10];
    
//    NSArray*array=dic[@"items"];
//    self.dataArray=[NSMutableArray arrayWithArray:array];
    self.dataArray=[NSMutableArray arrayWithArray:dic[@"items"]];
    [_tableView reloadData];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
