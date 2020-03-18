//
//  MovieTableViewCell.m
//  ObjectiveCProject
//
//  Created by Rodrigo Giglio on 18/03/20.
//  Copyright © 2020 Rodrigo Giglio. All rights reserved.
//

#import "MovieTableViewCell.h"

@implementation MovieTableViewCell

//MARK: - Constants
+ (NSString *)identifier { return @"MovieTableViewCell"; }


//MARK: - Lifecycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//MARK: - Config
- (void)configureWithMovie:(Movie *)movie {
    
    /// Sets texts
    self.movieTitleLabel.text = movie.title;
    self.movieOverviewLabel.text = movie.overview;
    self.movieRatingLabel.text = movie.rating.stringValue;
    
    /// Layout
    self.movieCoverImageView.layer.cornerRadius = 8;
    
    /// Loads cover
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
