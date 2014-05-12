//
//  SearchResult.m
//  ePubSample
//
//  Created by Nuevalgo on 07/05/14.
//  Copyright (c) 2014 Nuevalgo. All rights reserved.
//

#import "SearchResult.h"
#import "Chapter.h"
@implementation SearchResult
-(void) searchString:(NSString*)query{
    self.results = [[NSMutableArray alloc] init];
    self.currentQuery=query;
    count=0;
    for (int i=0; i<_ePubContent._spine.count;i++) {
        [self searchString:query inChapterAtIndex:i];
    }
    NSLog(@"%@",_results);
}

- (void) searchString:(NSString *)query inChapterAtIndex:(int)index{
    currentChapterIndex = index;
    Chapter *chapter=[self.chapterArray objectAtIndex:index];
    
    
    NSRange range = NSMakeRange(0, chapter.text.length);
    range = [chapter.text rangeOfString:query options:NSCaseInsensitiveSearch range:range locale:nil];
    int hitCount=0;
    while (range.location != NSNotFound) {
        range = NSMakeRange(range.location+range.length, chapter.text.length-(range.location+range.length));
        range = [chapter.text rangeOfString:query options:NSCaseInsensitiveSearch range:range locale:nil];
        hitCount++;
    }
    
    if(hitCount!=0){
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, 320, self.bgView.frame.size.height-130)];
        [webView setDelegate:self];
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:chapter.spinePath]];
        [webView loadRequest:urlRequest];
        webView.tag=currentChapterIndex;
        [self.bgView addSubview:webView];
        webView.hidden=YES;
    } else {
        if((currentChapterIndex+1)<[self.ePubContent._spine count]){
            [self searchString:query inChapterAtIndex:(currentChapterIndex+1)];
        } else {
//            epubViewController.searching = NO;
        }
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@", error);
}

- (void) webViewDidFinishLoad:(UIWebView *)webView{
    NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
	
	NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
	"if (mySheet.addRule) {"
    "mySheet.addRule(selector, newRule);"								// For Internet Explorer
	"} else {"
    "ruleIndex = mySheet.cssRules.length;"
    "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
    "}"
	"}";
	
	
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')",100];
    
	
	[webView stringByEvaluatingJavaScriptFromString:varMySheet];
	
	[webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
	[webView stringByEvaluatingJavaScriptFromString:insertRule1];
	
	[webView stringByEvaluatingJavaScriptFromString:insertRule2];
	
    [webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
    
    [webView highlightAllOccurencesOfString:self.currentQuery];
    
    NSString* foundHits = [webView stringByEvaluatingJavaScriptFromString:@"results"];
    
    //    NSLog(@"%@", foundHits);
    
    NSMutableArray* objects = [[NSMutableArray alloc] init];
    
    NSArray* stringObjects = [foundHits componentsSeparatedByString:@";"];
    for(int i=0; i<[stringObjects count]; i++){
        NSArray* strObj = [[stringObjects objectAtIndex:i] componentsSeparatedByString:@","];
        if([strObj count]==3){
            [objects addObject:strObj];
        }
    }
    
    NSArray* orderedRes = [objects sortedArrayUsingComparator:^(id obj1, id obj2){
        int x1 = [[obj1 objectAtIndex:0] intValue];
        int x2 = [[obj2 objectAtIndex:0] intValue];
        int y1 = [[obj1 objectAtIndex:1] intValue];
        int y2 = [[obj2 objectAtIndex:1] intValue];
        if(y1<y2){
            return NSOrderedAscending;
        } else if(y1>y2){
            return NSOrderedDescending;
        } else {
            if(x1<x2){
                return NSOrderedAscending;
            } else if (x1>x2){
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }
    }];
    

    for(int i=0; i<[orderedRes count]; i++){
        NSArray* currObj = [orderedRes objectAtIndex:i];
        SearchResult *obj=[[SearchResult alloc]init];
        obj.hitIndex=webView.tag;
        obj.pageIndex=([[currObj objectAtIndex:1] intValue]/webView.bounds.size.height);
        NSLog(@"%d",[[currObj objectAtIndex:1] intValue]);
        NSLog(@"%f",webView.bounds.size.height);

        obj.searchString=_currentQuery;
        obj.fullText= [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"unescape('%@')", [currObj objectAtIndex:2]]];
        [_results addObject:obj];
    }
    count++;
    if((currentChapterIndex+1)<[self.ePubContent._spine count]){
        [self searchString:_currentQuery inChapterAtIndex:(currentChapterIndex+1)];
    } else {
//    epubViewController.searching = NO;
    }
    if(self.ePubContent._spine.count==count){
        [_delegate finishedSearching :_results];
    }
}

@end
