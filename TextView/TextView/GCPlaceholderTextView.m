//
//  GCPlaceholderTextView.m
//  GCLibrary
//
//  Created by Guillaume Campagna on 10-11-16.
//  Copyright 2010 LittleKiwi. All rights reserved.
//

#import "GCPlaceholderTextView.h"

//默认holder字体色值
#define Placeholeder_Font_color        @"#cdcdcd"

@interface GCPlaceholderTextView () 

@property (nonatomic, copy) NSString* realText;

- (void) beginEditing:(NSNotification*) notification;
- (void) endEditing:(NSNotification*) notification;

@end

@implementation GCPlaceholderTextView

@synthesize realTextColor;
@synthesize placeholder;

#pragma mark -
#pragma mark Initialisation

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    
    self.realTextColor = [UIColor blackColor];
}

#pragma mark - 开始编辑时
- (void) beginEditing:(NSNotification*) notification {
    if ([self.realText isEqualToString:self.placeholder]) {
        super.text = nil;
        self.textColor = self.realTextColor;
    }
}

#pragma mark - 结束编辑时
- (void) endEditing:(NSNotification*) notification {
    if ([self.realText isEqualToString:@""] || self.realText == nil) {
        //利用super存储
        super.text = self.placeholder;
        self.textColor = [self colorWithHexString:Placeholeder_Font_color];
    }else {
        //返回之前去掉首尾的回车和换行
        self.realText = [self removeEnterAndSpaceAtFromAndEnd:self.realText];
    }
}

#pragma mark -

#pragma mark Setter/Getters

- (void) setPlaceholder:(NSString *)aPlaceholder {
    if ([self.realText isEqualToString:placeholder]) {
        self.text = aPlaceholder;
    }
    
    placeholder = aPlaceholder;
    
    [self endEditing:nil];
}

- (NSString *) text {
    NSString* text = [super text];
    if ([text isEqualToString:self.placeholder]) return @"";
    return text;
}

- (void) setText:(NSString *)text {
    
    if (text.length == 0) {
        super.text = self.placeholder;
    }else {
        super.text = text;
    }
    
    if ([text isEqualToString:self.placeholder]) {
        self.textColor = [self colorWithHexString:Placeholeder_Font_color];
    }else {
        self.textColor = self.realTextColor;
    }
}

- (NSString *)realText {
    
    return [super text];
}

- (void) setTextColor:(UIColor *)textColor {
    if ([self.realText isEqualToString:self.placeholder]) {
        if ([textColor isEqual:[self colorWithHexString:Placeholeder_Font_color]]){
           [super setTextColor:textColor];
        }else{
           self.realTextColor = textColor;
        }
    }else {
        self.realTextColor = textColor;
        [super setTextColor:textColor];
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 去除首尾换行和空格
- (NSString *)removeEnterAndSpaceAtFromAndEnd:(NSString *)sss
{
    int startIndex = 0;
    for (; startIndex < sss.length;)
    {
        NSString *first = [sss substringWithRange:NSMakeRange(startIndex, 1)];
        if ([first isEqualToString:@"\n"] || [first isEqualToString:@" "])
        {
            startIndex++;
        }
        else {
            break;
        }
    }
    sss = [sss substringFromIndex:startIndex];
    
    NSInteger endIndex = sss.length - 1;
    for ( ; endIndex >= 0 ; )
    {
        NSString *end = [sss substringWithRange:NSMakeRange(endIndex, 1)];
        if ([end isEqualToString:@"\n"] || [end isEqualToString:@" "])
        {
            endIndex--;
        }else {
            break;
        }
    }
    sss = [sss substringToIndex:endIndex + 1];
    return sss;
}

#pragma mark - 返回颜色
- (UIColor *) colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0];
}

@end
