//
//  MovieDetailViewController.h
//  ObjectiveCProject
//
//  Created by Rodrigo Giglio on 18/03/20.
//  Copyright © 2020 Rodrigo Giglio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieDetailViewController : UIViewController

// MARK: - Outlets
@property (weak, nonatomic) IBOutlet UIImageView *movieCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieRatingLabel;
@property (weak, nonatomic) IBOutlet UITextView *movieOverviewTextView;

// MARK: - Methods
- (void)configureWithMovie:(Movie *)movie;


@end

NS_ASSUME_NONNULL_END
