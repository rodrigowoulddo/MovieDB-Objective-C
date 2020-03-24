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

static NSCache *imageCache;

@implementation MovieDBRequest

NSString *popularMoviesBaseUrl = @"https://api.themoviedb.org/3/movie/popular?api_key=2e8128cacbf1cbae9230177e3e5bc171";
NSString *nowPlayingMoviesBaseUrl = @"https://api.themoviedb.org/3/movie/now_playing?api_key=2e8128cacbf1cbae9230177e3e5bc171";
NSString *searchUrl = @"https://api.themoviedb.org/3/search/movie?api_key=2e8128cacbf1cbae9230177e3e5bc171";
NSString *baseImageURL = @"https://image.tmdb.org/t/p/";

+ (NSCache *) imageCache {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = NSCache.new;
    });
    return imageCache;
}

+(NSString *) searchURLWithQuery: (NSString *)query {
    return [NSString stringWithFormat:@"%@&query=%@", searchUrl, query];
}

+ (void) getPopularMoviesWithHandler:(void (^)(NSMutableArray *))handler {
    
    NSLog(@"Searching for popular movies");
    
    NSURL *url = [NSURL URLWithString: popularMoviesBaseUrl];
    
    NSLog(@"Sending request: %@", url);
    
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

+ (void) getNowPlayingMoviesWithHandler:(void (^)(NSMutableArray *))handler {
    
    NSLog(@"Searching for popular movies");
    
    NSURL *url = [NSURL URLWithString: nowPlayingMoviesBaseUrl];
    
    NSLog(@"Sending request: %@", url);
    
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

+ (NSData *) getCacheImageWithUrl: (NSString *) url {
    
    NSData *imageData = [[self imageCache] objectForKey:url];
    
    return imageData;
}

+ (void) cacheImageData: (NSData *) data atUrl: (NSString *) url {
    
    [[self imageCache] setObject:data forKey:url];
}

+ (NSURLSessionTask *) getMovieImageDataFromPath:(NSString *)movieImagePath andSize:(ImageSize)size andHandler:(void (^)(NSData *))handler {
    
    
    NSString *imagSizeUrl;
    
    switch (size) {
        case small: imagSizeUrl = @"w154"; break;
        case medium: imagSizeUrl = @"w342"; break;
        case large: imagSizeUrl = @"original"; break;
    }
    
    
    NSString *imageFullPath = [baseImageURL stringByAppendingFormat: @"%@%@", imagSizeUrl, movieImagePath];
    
    /// Checks cache for image data
    NSData *cachedImageData = [self getCacheImageWithUrl:imageFullPath];
    if ( cachedImageData != nil ) {
        
        NSLog(@"Did found image on cache.");
        
        handler(cachedImageData);
        return nil;
    }
    
    
        NSURL *url = [NSURL URLWithString:imageFullPath];

        NSURLSessionTask *session = [NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if(error) {
                NSLog(@"Failed to geet image data: %@", error);
                handler(nil);
                return;
            }
            
            [self cacheImageData:data atUrl:imageFullPath];
            handler(data);
            
        }];
    
    [session resume]; /// Sends the request
    return session;
}

+ (NSURLSessionTask *) searchMoviesWithQuery:(NSString *)query andHandler:(void (^)(NSMutableArray *))handler {
    
    NSLog(@"Searching for movies with query: %@", query);
    
    /// Encode query
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[] ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedQuery = [query stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    NSURL *url = [NSURL URLWithString: [self searchURLWithQuery:encodedQuery]];
    
    NSLog(@"Sending request: %@", url);
    
    
    NSURLSessionTask *task = [NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data == nil) return;
        
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
        
        
    }];
    
    [task resume];
    return task;
}

@end

