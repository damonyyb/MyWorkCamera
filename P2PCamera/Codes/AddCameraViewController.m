//
//  AddCameraViewController.m
//  P2PCamera
//
//  Created by Raindy on 16/3/1.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "AddCameraViewController.h"
#import "AddDetailViewController.h"
//#import "QRViewController.h"
#import "AudioPlayer.h"
#import "CameraObject.h"
#import "CameraManager.h"
#import "BBCell.h"
#import "SVProgressHUD.h"
#import "P2PCamera-Swift.h"

static NSString *const Bcell = @"Bcell";
static NSString *const Ccell = @"Ccell";
@interface AddCameraViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong)UIButton *addBtn;
@property (nonatomic,strong)UIButton *scanBtn;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSArray *remoteMovies;
//@property (nonatomic,strong)AudioPlayer *audioPlayer;

@end

@implementation AddCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取数据
    [self searchCamera];
    //刷新界面
    if (self.dataSource.count != 0) {
        [self.tableView reloadData];
    }
}

- (void)setupUI{
    [self setMyNavBar];
    self.titleLabel.text = NSLocalizedString(@"title_new", @"");
    self.view.backgroundColor = [UIColor whiteColor];
    [self showRightButton];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.view addSubview:self.addBtn];
    [self.view addSubview:self.scanBtn];
    [self.view addSubview:self.tableView];
}

#pragma mark - TableViewCell Delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return false;
}

//删除按钮点击事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"A_title", @"") message:NSLocalizedString(@"A_delete_sure", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"A_cancel", @"") otherButtonTitles:NSLocalizedString(@"A_sure", @""), nil];
    alertView.tag = 9999+indexPath.row;
    [alertView show];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"delete", @"");
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//}

#pragma mark - 按钮响应事件

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(50*AUTO_WIDTH, 90*AUTO_HEIGHT, 60*AUTO_WIDTH, 20*AUTO_HEIGHT);
        [_addBtn setTitle:NSLocalizedString(@"N_add", @"") forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UIButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanBtn.frame = CGRectMake(210*AUTO_WIDTH, 90*AUTO_HEIGHT, 60*AUTO_WIDTH, 20*AUTO_HEIGHT);
        [_scanBtn setTitle:NSLocalizedString(@"N_QRCode", @"") forState:UIControlStateNormal];
        [_scanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _scanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_scanBtn addTarget:self action:@selector(scanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanBtn;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 130*AUTO_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[BBCell class] forCellReuseIdentifier:Bcell];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:Ccell];
    }
    return _tableView;
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*AUTO_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BBCell *cell = [tableView dequeueReusableCellWithIdentifier:Bcell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CameraObject *object = self.dataSource[indexPath.row];
    [cell setCell:indexPath.row camera:object];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CameraObject *object = self.dataSource[indexPath.row];
    if([object.password isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"A_title", @"") message:NSLocalizedString(@"N_setcam", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"A_cancel", @"") otherButtonTitles:NSLocalizedString(@"A_sure", @""), nil];
        alert.tag = 102;
        [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        UITextField *textField1 = [alert textFieldAtIndex:0];
        UITextField *textField2 = [alert textFieldAtIndex:1];
        textField1.placeholder = NSLocalizedString(@"N_insertName", @"");
        textField1.uid = object.uid;
        textField2.placeholder = NSLocalizedString(@"N_insertPsd", @"");
        [alert show];
    } else {
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20*AUTO_HEIGHT;
}

//组头部复用
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:Ccell];
    if (self.label==nil) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(10*AUTO_WIDTH, 0, 160*AUTO_WIDTH, 20*AUTO_HEIGHT)];
        self.label.text = [NSString stringWithFormat:@"%@%lu%@",NSLocalizedString(@"N_Find", @""),(unsigned long)[self.dataSource count],NSLocalizedString(@"N_Camera", @"")];
        self.label.font = [UIFont systemFontOfSize:12];
        [headerView addSubview:self.label];
    }
    
    return headerView;
}
//- (void)updataHeaderFooterView:(int)number{
//    self.label.text = [NSString stringWithFormat:@"找到%d个摄影机!",number];
//}

- (void)addBtnClicked:(UIButton *)btn{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"A_title", @"") message:NSLocalizedString(@"N_pleaseInsert", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"A_cancel", @"") otherButtonTitles:NSLocalizedString(@"A_sure", @""), nil];
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    alert.tag = 101;
    UITextField *textField1 = [alert textFieldAtIndex:0];
    UITextField *textField2 = [alert textFieldAtIndex:1];
    
    textField1.placeholder = NSLocalizedString(@"N_uid_P", @"");
    textField2.placeholder = NSLocalizedString(@"N_psd_P", @"");
    
    [alert show];
}

// alertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101){
        if (buttonIndex == 1) {
            UITextField *textField1 = [alertView textFieldAtIndex:0];
            UITextField *textField2 = [alertView textFieldAtIndex:1];
            if ([textField1.text length] == 0 || [textField2.text length] == 0){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"A_title", @"") message:NSLocalizedString(@"A_notNull", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"A_sure", @"") otherButtonTitles:nil, nil];
                [alert show];
            } else {
                CameraObject *object = [[CameraObject alloc]init];
                object.uid = textField1.text;
                object.password = textField2.text;
                
                if ([[CameraManager sharedInstance] insertObject:object]) {
                    [self.dataSource addObject:object];
                    [self.tableView reloadData];
                }
            }
        }
    } else
    if (alertView.tag == 102){
        if (buttonIndex == 1) {
            UITextField *textField1 = [alertView textFieldAtIndex:0];
            UITextField *textField2 = [alertView textFieldAtIndex:1];
            if ([textField2.text length] == 0 || [textField1.text length] == 0){
                UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"A_title", @"") message:NSLocalizedString(@"A_notNull", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"A_sure", @"") otherButtonTitles:nil, nil];

                [alert show];
            } else {
                CameraObject *object = [[CameraObject alloc]init];
                object.uid = textField1.uid;
                object.name = textField1.text;
                object.password = textField2.text;
                
                if ([[CameraManager sharedInstance] insertObject:object]) {
                    for (int i = 0; i < self.dataSource.count; i++) {
                        CameraObject *obj = self.dataSource[i];
                        if ([obj.uid isEqualToString:textField1.uid]) {
                            self.dataSource[i] = object;
                        }
                    }
                    [self.tableView reloadData];
                }
            }
        }
    } else {
        if (buttonIndex == 0) {
            return;//取消
        } else {
            //确认
            [[CameraManager sharedInstance]deleteObject:self.dataSource[alertView.tag - 9999]];
            [self.dataSource removeObjectAtIndex:alertView.tag - 9999];
            [self.tableView reloadData];
        }
    }
}

- (void)rightButtonAction:(UIButton *)button{
    [self searchCamera];
}

- (void)searchCamera{
    [self.dataSource removeAllObjects];
    [[[TutkP2PAVClient alloc]init] SearchAndConnect:^(NSString *str) {
        if ([str isEqualToString:@""] || str == NULL){
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"N_notFindCam", @"")];
        } else {
            
            NSArray *arr = [[CameraManager sharedInstance] findAllObjects];
            for (CameraObject *obj in arr) {
                if ([obj.uid isEqualToString:str]) {
                    [self.dataSource addObject:obj];
                    NSLog(@"%@",obj.name);
                    [self.tableView reloadData];
                    return;
                }
            }
            CameraObject *obj = [[CameraObject alloc]init];
            obj.uid = str;
            obj.password = @"";
            obj.name = @"";
            [self.dataSource addObject:obj];
            [self.tableView reloadData];
//            [[CameraManager sharedInstance] insertObject:obj];
        }
    }];
}



- (void)scanBtnClicked:(UIButton *)btn{

#warning 设备登陆测试
    
    QRViewController *qrVC = [[QRViewController alloc]init];
    [self.navigationController pushViewController:qrVC animated:YES];
}
@end
