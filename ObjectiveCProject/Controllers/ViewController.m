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
#import "MovieDetailViewController.h"

@interface ViewController ()

//MARK: - Variables
@property (strong, nonatomic) NSMutableArray<Movie *> *popularMovies;
@property (strong, nonatomic) NSMutableArray<Movie *> *nowPlayingMovies;
@property (strong, nonatomic) Movie *selectedMovie;
@property int page;

@end

@implementation ViewController

// MARK: - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popularMovies = NSMutableArray.new;
    self.nowPlayingMovies = NSMutableArray.new;
    self.page = 1; // multiple paging may be implemented it the future
    [self loadMovies];
    
    self.title = @"Movies";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}


-(void) loadMovies {
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [MovieDBRequest getPopularMoviesWithPage:self.page andHandler:^(NSMutableArray *movies) {
        
        [self.popularMovies addObjectsFromArray:movies];
        dispatch_group_leave(group);
        
    }];
    
    dispatch_group_enter(group);
    [MovieDBRequest getNowPlayingMoviesWithPage:self.page andHandler:^(NSMutableArray *movies) {
        
        [self.nowPlayingMovies addObjectsFromArray:movies];
        dispatch_group_leave(group);
        
    }];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    
}



-(BOOL) isLastIndex: (long) index {
    return (index == self.popularMovies.count - 1);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0: return self.popularMovies.count;
        case 1: return self.nowPlayingMovies.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 148;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"Popular";
        case 1: return @"Now Playing";
    }
    
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    /*
     
     // On standby
     
     if ([self isLastIndex:indexPath.row]) {
     [self loadMovies];
     }
     
     */
    
    if (indexPath.section != 1) {
        NSLog(@"Different than 1");
    }
    
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: [MovieTableViewCell identifier] forIndexPath:indexPath];
    
    NSMutableArray *movieArray;
    
    switch (indexPath.section) {
        case 0: movieArray = self.popularMovies;
        case 1: movieArray = self.nowPlayingMovies;
    }
    
    Movie *movie = movieArray[indexPath.row];
    
    [cell configureWithMovie:movie];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *movieArray;
    
    switch (indexPath.section) {
        case 0: movieArray = self.popularMovies;
        case 1: movieArray = self.nowPlayingMovies;
    }
    
    Movie *selectedMovie = movieArray[indexPath.row];
    self.selectedMovie = selectedMovie;
    
    [self performSegueWithIdentifier:@"detail" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    MovieDetailViewController *movieDetailVC = [segue destinationViewController];
    
    movieDetailVC.movie = self.selectedMovie;
}

@end
