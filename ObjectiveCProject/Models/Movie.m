//
//  Movie.m
//  ObjectiveCProject
//
//  Created by Rodrigo Giglio on 17/03/20.
//  Copyright © 2020 Rodrigo Giglio. All rights reserved.
//

#import "Movie.h"

@implementation Movie

-(id) initWithDictionary:(NSDictionary *)dictionary {
    
    self = [self init];
    
    if (self) {
        
        NSString *title = dictionary[@"title"];
        NSString *overview = dictionary[@"overview"];
        NSNumber *rating = dictionary[@"vote_average"];
        NSString *imageUrl = dictionary[@"poster_path"];

        
        self.title = title;
        self.overview = overview;
        self.rating = rating;
        self.imageUrl = imageUrl;
    }
    
    return self;
}

@end
