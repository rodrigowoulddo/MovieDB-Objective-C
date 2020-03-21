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
@property (strong, nonatomic) NSMutableArray<Movie *> *searchedMovies;

@property (strong, nonatomic) NSURLSessionTask *currentSearchTask;

@property (strong, nonatomic) Movie *selectedMovie;


@end

@implementation ViewController

// MARK: - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popularMovies = NSMutableArray.new;
    self.nowPlayingMovies = NSMutableArray.new;
    self.searchedMovies = NSMutableArray.new;
    
    [self loadMovies];
    
    self.title = @"Movies";
    self.searchBar.delegate = self;
    self.searchBar.searchTextField.delegate = self;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}


// MARK: - Methods
-(void) loadMovies {
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [MovieDBRequest getPopularMoviesWithHandler:^(NSMutableArray *movies) {
        
        [self.popularMovies addObjectsFromArray:movies];
        dispatch_group_leave(group);
        
    }];
    
    dispatch_group_enter(group);
    [MovieDBRequest getNowPlayingMoviesWithHandler:^(NSMutableArray *movies) {
        
        [self.nowPlayingMovies addObjectsFromArray:movies];
        dispatch_group_leave(group);
        
    }];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    
}

-(void) searchForMoviesWithQuery: (NSString *) query {
    
    /*
     In case there is a search in progress,
     it is cancelled, in order to save data
     download and parsing.
     */
    [self.currentSearchTask cancel];
    
    self.currentSearchTask = [MovieDBRequest searchMoviesWithQuery:query andHandler:^(NSMutableArray *movies) {
        
        [self.searchedMovies addObjectsFromArray:movies];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
}

// MARK: - Table View Methods
-(BOOL) isLastIndex: (long) index {
    return (index == self.popularMovies.count - 1);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.searchedMovies.count > 0 )
        return 1;
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.searchedMovies.count > 0 )
        return self.searchedMovies.count;
    
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
    
    if (self.searchedMovies.count > 0 )
        return @"Results";
    
    switch (section) {
        case 0: return @"Popular";
        case 1: return @"Now Playing";
    }
    
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: [MovieTableViewCell identifier] forIndexPath:indexPath];
    
    NSMutableArray *movieArray;
    
    switch (indexPath.section) {
        case 0: movieArray = self.popularMovies;
        case 1: movieArray = self.nowPlayingMovies;
    }
    
    if (self.searchedMovies.count > 0 )
        movieArray = self.searchedMovies;

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
    
    if (self.searchedMovies.count > 0 )
        movieArray = self.searchedMovies;
    
    Movie *selectedMovie = movieArray[indexPath.row];
    self.selectedMovie = selectedMovie;
    
    [self performSegueWithIdentifier:@"detail" sender:nil];
}


// MARK: - Prepare for Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    MovieDetailViewController *movieDetailVC = [segue destinationViewController];
    
    movieDetailVC.movie = self.selectedMovie;
}


// MARK: - Text Field Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.text == 0) return;
    
    [self searchForMoviesWithQuery:textField.text];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   
    [textField resignFirstResponder];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar.searchTextField resignFirstResponder];
    self.searchedMovies = NSMutableArray.new;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });}

@end
