//
//  UIWebView+SearchWebView.h
//  ePubSample
//
//  Created by Nuevalgo on 09/05/14.
//  Copyright (c) 2014 Nuevalgo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (SearchWebView)
- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;
+(void)initMenu;
@end
