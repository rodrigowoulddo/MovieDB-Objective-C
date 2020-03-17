//
//  ViewController.m
//  ObjectiveCProject
//
//  Created by Rodrigo Giglio on 16/03/20.
//  Copyright © 2020 Rodrigo Giglio. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"

@interface ViewController ()

//MARK: - Variables
@property (strong, nonatomic) NSMutableArray<Movie *> *movies;

@end

@implementation ViewController


//MARK: - Constants
NSString *cellId = @"cell";
NSString *moviesUrl = @"https://api.themoviedb.org/3/trending/movie/week?api_key=2e8128cacbf1cbae9230177e3e5bc171";


// MARK: - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fechMovies];
    
    self.title = @"Movies";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier: cellId];
}

-(void) fechMovies {
    NSLog(@"Fetching movies...");
    
    NSURL *url = [NSURL URLWithString:moviesUrl];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Finished fetching Movies.");
        
        /// Uncomment these lines to se
        /// the returned movies list printed
        /// on console
        /*
        NSString *jsonResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@", jsonResponse);
        */
        
        NSError *err;
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (err) {
            NSLog(@"Failed to serialize data into JSON: %@", err);
            return;
        }
        
        self.movies = NSMutableArray.new;
        
        NSArray *moviesArray = resultJSON[@"results"];
        for (NSDictionary *movieDictionary in moviesArray) {
            Movie *movie = Movie.new;
            movie = [movie initWithDictionary:movieDictionary];
            
            [self.movies addObject:movie];
        }
        
        NSLog(@"Did fetch json to object array");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }] resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId forIndexPath:indexPath];
    
    Movie *movie = self.movies[indexPath.row];
    
    cell.textLabel.text = movie.title;
    
    return cell;
    
}

@end
