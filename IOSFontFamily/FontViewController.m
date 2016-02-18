//
//  FontViewController.m
//  IOSFontFamily
//
//  Created by 徐惠雨 on 15/5/13.
//  Copyright (c) 2015年 XFoxer. All rights reserved.
//

#import "FontViewController.h"


#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define kNavHeight 64.0f
#define kTabHeight 40.0f

@interface FontViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation FontViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"字体家族";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createTabView];
    [self.view addSubview:[self createTableView]];
}


- (void)createTabView
{
    UIView *tabView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavHeight, ScreenWidth, kTabHeight)];
    [tabView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tabView];
    
    
    CGFloat bWidth = 60.0f;
    CGFloat hMargin = 3.0f;
    CGFloat sMargin = 5.0f;
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(sMargin, hMargin, ScreenWidth - bWidth - 2*sMargin, kTabHeight - hMargin*2)];
    [_textField setTextAlignment:NSTextAlignmentLeft];
    [_textField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    
    _textField.placeholder = @"请输入文字"; //默认显示的字
    _textField.secureTextEntry = NO; //密码
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    [tabView addSubview:_textField];
    
    UIButton *setBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - bWidth, 0, bWidth, kTabHeight)];
    [setBtn setBackgroundColor:[UIColor clearColor]];
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    [setBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(fontSetClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:setBtn];
}

- (void)fontSetClick:(UIButton *)font
{
    if ([[_textField text] length] > 0) {
        [_textField resignFirstResponder];
        [_tableView reloadData];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入文字" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


//新建表格
- (UITableView *)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kNavHeight + kTabHeight, ScreenWidth, ScreenHeight - kTabHeight - kNavHeight) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setShowsHorizontalScrollIndicator:NO];
    [_tableView setShowsVerticalScrollIndicator:YES];
    [_tableView setMultipleTouchEnabled:NO];
    [_tableView setDelaysContentTouches:NO];
    return _tableView;
}

#pragma mark - TableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[UIFont familyNames] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *familyName = [[UIFont familyNames] objectAtIndex:section];
    return [[UIFont fontNamesForFamilyName:familyName] count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //字体家族名称
    NSString * fontName = [[UIFont familyNames] objectAtIndex:section];
    if([fontName isEqualToString:@"Menlo Regular"]||[fontName isEqualToString:@"Menlo Bold"]||[fontName isEqualToString:@"Zapf Dingbats"] ){
        NSLog(@"%@",fontName);
    }
    return [[UIFont familyNames] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    return index;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    cell.textLabel.textColor = indexPath.row %2 ? [UIColor orangeColor] : [UIColor magentaColor];
    
    //字体家族名称
    NSString *familyName= [[UIFont familyNames] objectAtIndex:indexPath.section];
    //字体家族中的字体库名称
    NSString *fontName  = [[UIFont fontNamesForFamilyName:familyName] objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:fontName size:15];
    
    //查找微软雅黑字体Zapf Dingbats
    if([fontName isEqualToString:@"NOTOSANSHANS-LIGHT"]){
        NSLog(@"Find Font %@",fontName);
    }
    
    [cell.textLabel setNumberOfLines:0];
    if ([_textField.text length] > 0) {
       cell.textLabel.text = [NSString stringWithFormat:@"%@",_textField.text];
    }
    else
    {
       cell.textLabel.text = [NSString stringWithFormat:@"这是一种字体" /*fontName*/];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //字体家族名称
    NSString *familyName= [[UIFont familyNames] objectAtIndex:indexPath.section];
    //字体家族中的字体库名称
    NSString *fontName  = [[UIFont fontNamesForFamilyName:familyName] objectAtIndex:indexPath.row];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"已选择字体" message:fontName delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
}

#pragma mark - Table Custom Cell

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   
}

@end
