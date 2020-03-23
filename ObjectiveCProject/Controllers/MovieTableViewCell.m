//
//  MovieTableViewCell.m
//  ObjectiveCProject
//
//  Created by Rodrigo Giglio on 18/03/20.
//  Copyright © 2020 Rodrigo Giglio. All rights reserved.
//

#import "MovieTableViewCell.h"
#import "MovieDBRequest.h"

@interface MovieTableViewCell()

@property (strong, nonatomic) NSURLSessionTask *coverSessionTask;

@end

@implementation MovieTableViewCell

// MARK: - Constants
+ (NSString *)identifier { return @"MovieTableViewCell"; }


// MARK: - Lifecycle
- (void)awakeFromNib {
    [super awakeFromNib];
}

// MARK: - Config
- (void)configureWithMovie:(Movie *)movie {
    
    /// Sets texts
    self.movieTitleLabel.text = movie.title;
    self.movieOverviewLabel.text = movie.overview;
    
    /// Sets rating
    float roundedRating = roundf(10 * movie.rating.floatValue) / 10;
    NSString *roundedRatingString = [NSString stringWithFormat:@"%.01f",roundedRating ];
    self.movieRatingLabel.text = roundedRatingString;
    
    self.movieCoverImageView.layer.cornerRadius = 8;
    
    self.movieCoverImageView.image = nil;/// Clears current cover
    
    /// Cancels current cover loading
    /*
     If there is a image request in course,
     it is canceled. This way, images wont "blink",
     and network use will be lower
    */
    [self.coverSessionTask cancel];
    
    
    /// Loads movie cover
    NSLog(@"Will load cover for: %@", movie.title);
    
    if (movie.imageUrl == (NSString *)[NSNull null]) {
        NSLog(@"No cover image available");
        return;
    }

    NSMutableString *baseImageUrl = [NSMutableString stringWithString:@"https://image.tmdb.org/t/p/w154"];
    NSString *imageURL = [baseImageUrl stringByAppendingString:movie.imageUrl];
    
    NSLog(@"Loading cover from: %@", imageURL);
    self.coverSessionTask = [MovieDBRequest getMovieImageDataFromURL:imageURL andHandler:^(NSData *data)  {

        if ( data == nil ) {
            return;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [UIImage imageWithData:data];
            
            if (image == nil) {
                NSLog(@"Error converting data response to image");
                return;
            }
            
            self.movieCoverImageView.image = image;
            NSLog(@"Successfuly loaded image");
            
        });
        
    }];
}

@end
