//
//  Movie.h
//  ObjectiveCProject
//
//  Created by Rodrigo Giglio on 17/03/20.
//  Copyright © 2020 Rodrigo Giglio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *overview;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSString *imageUrl;

-(id) initWithDictionary:(NSDictionary *) dictionary;

@end
