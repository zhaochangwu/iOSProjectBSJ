//
//  SUPPostWordViewController.m
//  BSJProject
//
//  Created by NShunJian on 2018/7/29.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPPostWordViewController.h"
#import "SUPPlaceholderTextView.h"
#import "SUPAddTagToolbar.h"

@interface SUPPostWordViewController () <UITextViewDelegate>
/** 文本输入控件 */
@property (nonatomic, weak) SUPPlaceholderTextView *textView;
/** 工具条 */
@property (nonatomic, weak) SUPAddTagToolbar *toolbar;
@end

@implementation SUPPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTextView];
    
    [self setupToolbar];
}

/**
 * 监听键盘的弹出和隐藏
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 键盘最终的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0,  keyboardF.origin.y - SUPScreenHeight);
    }];
}

- (void)setupToolbar
{
    SUPAddTagToolbar *toolbar = [SUPAddTagToolbar viewFromXib];
    toolbar.width = self.view.width;
    toolbar.SUP_y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
    [SUPNoteCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupTextView
{
    SUPPlaceholderTextView *textView = [[SUPPlaceholderTextView alloc] init];
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    textView.frame = self.view.bounds;
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)setupNav
{
    self.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO; // 默认不能点击
    // 强制刷新
    [self.navigationController.navigationBar layoutIfNeeded];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post
{
    SUPLogFunc;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 先退出之前的键盘
//    [self.view endEditing:YES];   看情况如果toolBar没显示可用它
    // 再叫出键盘
    [self.textView becomeFirstResponder];
}

#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
