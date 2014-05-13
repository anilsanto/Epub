//
//  UIWebView+SearchWebView.m
//  ePubSample
//
//  Created by Nuevalgo on 09/05/14.
//  Copyright (c) 2014 Nuevalgo. All rights reserved.
//

#import "UIWebView+SearchWebView.h"

@implementation UIWebView (SearchWebView)
- (NSInteger)highlightAllOccurencesOfString:(NSString*)str
{
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"SearchWebView" ofType:@"js" inDirectory:@""];
    NSData *fileData  = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [self stringByEvaluatingJavaScriptFromString:jsString];
    NSString *startSearch = [NSString stringWithFormat:@"HighlightAllOccurencesOfString('%@')",str];
    
    [self stringByEvaluatingJavaScriptFromString:startSearch];
    NSString *result= [self stringByEvaluatingJavaScriptFromString:@"SearchResultCount"];
    
    return [result integerValue];
}

- (void)removeAllHighlights
{
    [self stringByEvaluatingJavaScriptFromString:@"RemoveAllHighlights()"];
}
- (NSString *)highlightString  {
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"SearchWebView" ofType:@"js" inDirectory:@""];
    NSData *fileData  = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [self stringByEvaluatingJavaScriptFromString:jsString];
    NSString *startSearch = [NSString stringWithFormat:@"gettagfunction()"];
    
    [self stringByEvaluatingJavaScriptFromString:startSearch];
    NSString *result= [self stringByEvaluatingJavaScriptFromString:@"pos"];
    
    return result;
}

- (void)removeHighlights
{
    [self stringByEvaluatingJavaScriptFromString:@"HighlightText()"];
}



+(void)initMenu{
    UIMenuItem *itemA = [[UIMenuItem alloc] initWithTitle:@"Highlight" action:@selector(hightlight)];
    UIMenuItem *itemB = [[UIMenuItem alloc] initWithTitle:@"Comment" action:@selector(comment)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:itemA, itemB, nil]];
    
}
-(void)hightlight{
    NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('mark', 'background-color: yellow;')"];
    [self stringByEvaluatingJavaScriptFromString:setHighlightColorRule];
    NSLog(@"Result  :  %@", [self stringByEvaluatingJavaScriptFromString:@"window.getSelection().getRangeAt(0).startOffset"]);
    NSString *count=[self highlightString];
    NSLog(@"%@",count);
}
-(void)comment{
    [self hightlight];
    UIView *noteView=[[UIView alloc]initWithFrame:CGRectMake(60, 50, 200, 240)];
    noteView.backgroundColor=[UIColor colorWithRed:((float) 237.0f / 255.0f)
                                             green:((float) 236.0f/ 255.0f)
                                              blue:((float) 219.0f / 255.0f)
                                             alpha:1.0f];
    [self addSubview:noteView];
    UITextView *note=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, 180, 180)];
    [noteView addSubview:note];
    UIButton *addNote=[[UIButton alloc]initWithFrame:CGRectMake(10, 200, 80, 30)];
    [addNote addTarget:self action:@selector(addCommnt:) forControlEvents:UIControlEventTouchUpInside];
    [addNote setTitle:@"Add Note" forState:UIControlStateNormal];
    [addNote setBackgroundColor:[UIColor greenColor]];
    [self setLayer:addNote];
    [noteView addSubview:addNote];

    UIButton *clear=[[UIButton alloc]initWithFrame:CGRectMake(100, 200, 80, 30)];
    [clear setTitle:@"Clear" forState:UIControlStateNormal];
    [clear addTarget:self action:@selector(clear :) forControlEvents:UIControlEventTouchUpInside];
    [clear setBackgroundColor:[UIColor redColor]];
    [self setLayer:clear];
    [noteView addSubview:clear];
}
-(void)addCommnt :(UIButton *)btn{
    
    UIView *bgView=(UIView *)[btn superview];
    UITextView *text;
    for(id note in bgView.subviews){
        if([note isKindOfClass:[UITextView class]]){
            text=(UITextView *)note;
        }
    }
    NSLog(@"%@",text.text);
    [bgView removeFromSuperview];
    bgView=nil;
}
-(void)clear :(UIButton *)btn{
    UIView *bgView=(UIView *)[btn superview];
    [bgView removeFromSuperview];
    bgView=nil;
}
-(void)setLayer :(UIButton *)btn{
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = btn.layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:0.8f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.7f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.6f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.5f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.6f],
                            [NSNumber numberWithFloat:0.7f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [btn.layer addSublayer:shineLayer];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL can = [super canPerformAction:action withSender:sender];
    if (action == @selector(hightlight) || action == @selector(comment))
    {
        can = YES;
    }
    else{
        return NO;
    }
    NSLog(@"%@ perform action %@ with sender %@.", can ? @"can" : @"cannot", NSStringFromSelector(action), sender);
    return can;
}
@end
