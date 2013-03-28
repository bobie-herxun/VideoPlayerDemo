//
//  Videos.h
//  VideoPlayerDemo
//
//  Created by BobieAir on 13/3/27.
//  Copyright (c) 2013年 BobieAir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Videos : NSManagedObject

@property (nonatomic, retain) NSString * filepath;
@property (nonatomic, retain) NSNumber * downloadProgress;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * thumbnailFilepath;
@property (nonatomic, retain) NSString * videourl;
@property (nonatomic, assign) BOOL       downloading;

@end
