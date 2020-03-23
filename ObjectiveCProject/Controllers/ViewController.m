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
@property (strong, nonatomic) Movie *selectedMovie;

@property (strong, nonatomic) UISearchController *searchBarController;

@property (nonatomic) BOOL showldDisplaySearch;

@property (strong, nonatomic) NSURLSessionTask *currentSearchTask;

@end

@implementation ViewController

// MARK: - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Movies";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    [self setupSearchBar];
    
    [self loadMovies];
}


// MARK: - Methods
-(void) setupSearchBar {
    
    /// Creates searchbar
    self.searchBarController = UISearchController.new;
    
    /// Sets searchbar appearence and behaiviour
    [self.searchBarController.searchBar sizeToFit];
    self.searchBarController.obscuresBackgroundDuringPresentation = false;
    self.searchBarController.hidesNavigationBarDuringPresentation = true;
    self.searchBarController.searchBar.searchTextField.clearButtonMode = UITextFieldViewModeNever;
    self.searchBarController.searchBar.returnKeyType = UIReturnKeyDone;
    
    /// Sets searchbar delegates
    self.searchBarController.searchBar.delegate = self;
    self.searchBarController.searchBar.searchTextField.delegate = self;
    
    
    /// Adds searchbar to navigation
    self.navigationItem.searchController = self.searchBarController;

}

-(void) loadMovies {
    
    self.popularMovies = NSMutableArray.new;
    self.nowPlayingMovies = NSMutableArray.new;
        
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
        self.showldDisplaySearch = NO;
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
    
    self.searchedMovies = NSMutableArray.new;
    
    [self.searchBarController.searchBar setShowsCancelButton: YES animated: YES];
    
    self.currentSearchTask = [MovieDBRequest searchMoviesWithQuery:query andHandler:^(NSMutableArray *movies) {
        
        [self.searchedMovies addObjectsFromArray:movies];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.showldDisplaySearch = YES;
            [self.tableView reloadData];
        });
        
    }];
}

- (void)cancelSearch {
    
    [self.currentSearchTask cancel];
    self.searchedMovies = NSMutableArray.new;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showldDisplaySearch = NO;
        [self.tableView reloadData];
    });
    
    return;
}

// MARK: - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.showldDisplaySearch)
        return 1;
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.showldDisplaySearch) {
        
        return self.searchedMovies.count;

    } else {
        
        switch (section) {
            case 0: return self.popularMovies.count;
            case 1: return self.nowPlayingMovies.count;
        }
        
        return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 148;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (self.showldDisplaySearch) {
        
        return @"Results";

    } else {
        
        switch (section) {
            case 0: return @"Popular";
            case 1: return @"Now Playing";
        }
        
        return @"";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: [MovieTableViewCell identifier] forIndexPath:indexPath];
    
    NSMutableArray *movieArray;
    
    if (self.showldDisplaySearch) {
        
        movieArray = self.searchedMovies;
        
    } else {
        
        switch (indexPath.section) {
            case 0: movieArray = self.popularMovies;
            case 1: movieArray = self.nowPlayingMovies;
        }
    }

    Movie *movie = movieArray[indexPath.row];
    
    [cell configureWithMovie:movie];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *movieArray;
    
    if (self.showldDisplaySearch) {
        
        movieArray = self.searchedMovies;
        
    } else {
        
        switch (indexPath.section) {
            case 0: movieArray = self.popularMovies;
            case 1: movieArray = self.nowPlayingMovies;
        }
    }
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   
    [textField resignFirstResponder];
    return YES;
}


// MARK: - Search Bar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBarController.searchBar setShowsCancelButton: YES animated: YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBarController.searchBar setShowsCancelButton:NO animated:YES];
    self.searchBarController.searchBar.text = @"";
    [self cancelSearch];
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0) {
        [self cancelSearch];
        return;
    }
    
    [self searchForMoviesWithQuery:searchText];
}

@end
