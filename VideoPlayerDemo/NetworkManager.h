//
//  NetworkManager.h
//  VideoPlayerDemo
//
//  Created by Bobie on 3/14/13.
//  Copyright (c) 2013 BobieAir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (void)sendRequestGet:(NSString*)strAPIURL withPayload:(NSString*)strPayload completeCallback:(void (^)(NSData* data))completion;

@end
