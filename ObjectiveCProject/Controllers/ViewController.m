//
//  ViewController.m
//  ObjectiveCProject
//
//  Created by Rodrigo Giglio on 16/03/20.
//  Copyright © 2020 Rodrigo Giglio. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"
#import "MovieDBRequest.h"
#import "MovieTableViewCell.h"

@interface ViewController ()

//MARK: - Variables
@property (strong, nonatomic) NSMutableArray<Movie *> *movies;

@end

@implementation ViewController

// MARK: - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fechMovies];
    
    self.title = @"Movies";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
//    [self.tableView registerClass:MovieTableViewCell.class forCellReuseIdentifier: [MovieTableViewCell identifier]];
}

-(void) fechMovies {

    [MovieDBRequest getTrendingMoviesWithCompletionHandler:^(NSMutableArray *movies) {
        
        self.movies = movies;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 148;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: [MovieTableViewCell identifier] forIndexPath:indexPath];
    
    Movie *movie = self.movies[indexPath.row];
    
    [cell configureWithMovie:movie];
    
    return cell;
    
}

@end
