//
//  MovieDetailViewController.m
//  ObjectiveCProject
//
//  Created by Rodrigo Giglio on 18/03/20.
//  Copyright © 2020 Rodrigo Giglio. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "Movie.h"
#import "MovieDBRequest.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController


// MARK: - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Movie Detail";
    
    [self configureWithMovie:self.movie];
}


// MARK: - Private Methods
- (void)configureWithMovie:(Movie *)movie {
    
    /// Sets texts
    self.movieTitleLabel.text = movie.title;
    self.movieOverviewTextView.text = movie.overview;
    
    /// Sets rating
    float roundedRating = roundf(10 * movie.rating.floatValue) / 10;
    NSString *roundedRatingString = [NSString stringWithFormat:@"%.01f",roundedRating ];
    self.movieRatingLabel.text = roundedRatingString;
    
    /// Layout
    self.movieCoverImageView.layer.cornerRadius = 16;
    
    /// Loads movie cover
    NSLog(@"Will load cover for: %@", movie.title);
    
    if (movie.imageUrl == (NSString *)[NSNull null]) {
        NSLog(@"No cover image available");
        return;
    }
    
    NSLog(@"Loading cover from: %@", movie.imageUrl);
    [MovieDBRequest getMovieImageDataFromPath:movie.imageUrl  andSize:medium andHandler:^(NSData *data)  {

        if ( data == nil ) {
            NSLog(@"Image data response was NULL");
            self.movieCoverImageView.image = nil;
            return;
        }
        
        UIImage *image = [UIImage imageWithData:data];
        
        if (image == nil) {
            NSLog(@"Error converting data response to image");
            self.movieCoverImageView.image = nil;
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.movieCoverImageView.image = image;
            NSLog(@"Successfuly loaded image");
            
        });
        
    }];
    
}

@end
