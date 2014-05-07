//
//  Chapter.m
//  ePubSample
//
//  Created by Nuevalgo on 06/05/14.
//  Copyright (c) 2014 Nuevalgo. All rights reserved.
//

#import "Chapter.h"

@implementation Chapter
{
    int temp;
}
- (void)parseXMLFileAt:(NSString*)strPath{
    temp=0;
	_parser=[[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:strPath]];
	_parser.delegate=self;
	[_parser parse];
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	
	NSLog(@"Error Occured : %@",[parseError description]);
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	NSLog(@"%@",elementName);
    if([elementName isEqualToString:@"navMap"]){
        self.chapterTitle=[[NSMutableArray alloc]init];
    }
    if([elementName isEqualToString:@"navPoint"]){
        temp=1;
    }
    if([elementName isEqualToString:@"navLabel"]){
        temp=2;
    }
    if(temp==2){
        if([elementName isEqualToString:@"text"]){
            temp=3;
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(temp==3){
        temp=0;
        [_chapterTitle addObject:string];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
    [_delegate finishedParsing];
}
@end
