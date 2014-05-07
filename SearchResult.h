//
//  SearchResult.h
//  ePubSample
//
//  Created by Nuevalgo on 07/05/14.
//  Copyright (c) 2014 Nuevalgo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResult : NSObject
@property(nonatomic)int pageIndex;
@property(nonatomic,strong)NSString *fullText;
@property(nonatomic)int hitIndex;
@property(nonatomic,strong)NSString *searchString;
@end
