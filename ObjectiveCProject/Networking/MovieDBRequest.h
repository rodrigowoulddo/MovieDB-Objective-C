//
//  MovieDBRequest.h
//  ObjectiveCProject
//
//  Created by Rodrigo Giglio on 16/03/20.
//  Copyright © 2020 Rodrigo Giglio. All rights reserved.
//

#ifndef MovieDBRequest_h
#define MovieDBRequest_h

#import "Movie.h"

#endif /* MovieDBRequest_h */

@interface MovieDBRequest: NSObject

+ (void) getPopularMoviesWithHandler:(void (^)(NSMutableArray *))handler;
+ (void) getNowPlayingMoviesWithHandler:(void (^)(NSMutableArray *))handler;
+ (NSURLSessionTask *) getMovieImageDataFromURL:(NSString *)url andHandler:(void(^)(NSData *))handler;
+ (NSURLSessionTask *) searchMoviesWithQuery:(NSString *)query andHandler:(void (^)(NSMutableArray *))handler;

@end
