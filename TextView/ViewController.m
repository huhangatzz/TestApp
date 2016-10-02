//
//  ViewController.m
//  TextView
//
//  Created by huhang on 16/9/22.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "ViewController.h"
#import "GCPlaceholderTextView.h"

@interface ViewController ()<UITextViewDelegate>

/** UITextView */
@property (nonatomic,strong)GCPlaceholderTextView *textView;

@end

@implementation ViewController

- (GCPlaceholderTextView *)textView{

    if (!_textView) {
        GCPlaceholderTextView *textView = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 80)];
        textView.placeholder = @"请输入数据";
        textView.realTextColor = [UIColor redColor];
        textView.font = [UIFont systemFontOfSize:15];
        textView.layer.borderColor = [UIColor redColor].CGColor;
        textView.layer.borderWidth = 0.5;
        textView.delegate = self;
        [self.view addSubview:textView];
        _textView = textView;
    }
    return _textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.hidden = NO;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
  
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
