//
//  SearchResult.h
//  ePubSample
//
//  Created by Nuevalgo on 07/05/14.
//  Copyright (c) 2014 Nuevalgo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EpubContent.h"
#import "UIWebView+SearchWebView.h"
@interface SearchResult : NSObject<UIWebViewDelegate>
{
    int currentChapterIndex;
}
@property(nonatomic)int pageIndex;
@property(nonatomic,strong)NSString *fullText;
@property(nonatomic)int hitIndex;
@property(nonatomic,strong)NSString *searchString;
@property(nonatomic,strong)NSArray *chapterArray;
@property(nonatomic,strong)NSMutableArray *results;
@property(nonatomic,strong)NSString *currentQuery;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)EpubContent *ePubContent;
-(void) searchString:(NSString*)query;

@end
