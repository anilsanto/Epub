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
- (NSString *)highlightString :(NSString *)str :(NSString *)pos {
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"SearchWebView" ofType:@"js" inDirectory:@""];
    NSData *fileData  = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [self stringByEvaluatingJavaScriptFromString:jsString];
    NSString *startSearch = [NSString stringWithFormat:@"gettagfunction()"];
    
    [self stringByEvaluatingJavaScriptFromString:startSearch];
    NSString *result= [self stringByEvaluatingJavaScriptFromString:@"htmlinner"];
    
    return result;
}

- (void)removeHighlights
{
    [self stringByEvaluatingJavaScriptFromString:@"HighlightText()"];
}



+(void)initMenu{
    UIMenuItem *itemA = [[UIMenuItem alloc] initWithTitle:@"Highlight" action:@selector(a:)];
    UIMenuItem *itemB = [[UIMenuItem alloc] initWithTitle:@"B" action:@selector(b:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:itemA, itemB, nil]];
    
}
-(void)a:(id)as{
    NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('mark', 'background-color: yellow;')"];
    [self stringByEvaluatingJavaScriptFromString:setHighlightColorRule];
    NSLog(@"Result  :  %@", [self stringByEvaluatingJavaScriptFromString:@"window.getSelection().getRangeAt(0).startOffset"]);
    NSString *count=[self highlightString :[self stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"] :[self stringByEvaluatingJavaScriptFromString:@"window.getSelection().getRangeAt(0).startOffset"] ];
    NSLog(@"%@",count);
    
    
}
-(void)b:(id)as{
    
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL can = [super canPerformAction:action withSender:sender];
    if (action == @selector(a:) || action == @selector(b:))
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
