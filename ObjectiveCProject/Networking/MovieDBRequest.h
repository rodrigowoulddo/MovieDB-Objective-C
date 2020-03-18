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

+ (void) getTrendingMoviesWithCompletionHandler:(void(^)(NSMutableArray *))handler;

@end
