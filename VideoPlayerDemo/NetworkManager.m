//
//  NetworkManager.m
//  VideoPlayerDemo
//
//  Created by Bobie on 3/14/13.
//  Copyright (c) 2013 BobieAir. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (void)sendRequestGet:(NSString*)strAPIURL withPayload:(NSString*)strPayload completeCallback:(void (^)(NSData* data))completion
{
    NSLog(@"Sending HTTP request");
    NSLog(strAPIURL);
    NSLog(strPayload);
    
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:strAPIURL]];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse* response, NSData* responseData, NSError* error)
        {
            if (error == nil)
            {
                if (completion)
                    completion(responseData);
            }
        }];
}

@end
