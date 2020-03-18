//
//  MovieDBRequest.m
//  ObjectiveCProject
//
//  Created by Rodrigo Giglio on 16/03/20.
//  Copyright © 2020 Rodrigo Giglio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieDBRequest.h"


@interface MovieDBRequest()


@end

@implementation MovieDBRequest

NSString *moviesUrl = @"https://api.themoviedb.org/3/trending/movie/week?api_key=2e8128cacbf1cbae9230177e3e5bc171";

+ (void)getTrendingMoviesWithCompletionHandler:(void (^)(NSMutableArray *))handler {
    
    NSLog(@"Searching for movies...");
    
    NSURL *url = [NSURL URLWithString:moviesUrl];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Did receive API data.");
        
        /// Uncomment these lines to se
        /// the returned movies list printed
        /// on console
        /*
        NSString *jsonResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@", jsonResponse);
        */
        
        NSError *err;
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (err) {
            NSLog(@"Failed to serialize data into JSON: %@", err);
            handler(NSMutableArray.new);
            return;
        }
        
        NSArray *moviesDictionaryArray = resultJSON[@"results"];
        NSLog(@"Did serialize data into JSON.");
        
        NSMutableArray *movies = NSMutableArray.new;
        for (NSDictionary *movieDictionary in moviesDictionaryArray) {
            Movie *movie = Movie.new;
            movie = [movie initWithDictionary:movieDictionary];
            
            [movies addObject:movie];
        }
        
        NSLog(@"Did fetch json into movies array.");
        handler(movies);
        
        
    }] resume];
    
}

@end

