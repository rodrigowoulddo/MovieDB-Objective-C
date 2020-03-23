//
//  MovieDetailViewController.m
//  ObjectiveCProject
//
//  Created by Rodrigo Giglio on 18/03/20.
//  Copyright © 2020 Rodrigo Giglio. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "Movie.h"

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
    
    NSMutableString *baseImageUrl = [NSMutableString stringWithString:@"https://image.tmdb.org/t/p/w185"];
    NSString *imageURL = [baseImageUrl stringByAppendingString:movie.imageUrl];
    
    NSLog(@"Will load image from url: %@", imageURL);
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
        
        if ( data == nil ) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [UIImage imageWithData:data];
            self.movieCoverImageView.image = image;
            
        });
    });
    
}

@end
