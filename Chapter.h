//
//  Chapter.h
//  ePubSample
//
//  Created by Nuevalgo on 06/05/14.
//  Copyright (c) 2014 Nuevalgo. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ChapterDelegate <NSObject>

@optional
- (void)finishedParsing;
@end

@interface Chapter : NSObject<NSXMLParserDelegate>
{
    NSXMLParser *_parser;
}
@property (nonatomic, strong) NSMutableArray *chapterTitle;
@property (nonatomic, retain) id<ChapterDelegate> delegate;
- (void)parseXMLFileAt:(NSString*)strPath;
@end
