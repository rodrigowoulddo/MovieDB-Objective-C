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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movies = NSMutableArray.new;
    
    self.title = @"Movies";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier: cellId];
}

- (void) setUpMovies {
    
    Movie *movie = Movie.new;
    movie.imageUrl = @"https://upload.wikimedia.org/wikipedia/pt/6/6d/Kill_Bill_poster.jpg";
    movie.name = @"Kill Bill";
    movie.overview = @"This is Kill Bill's overview";
    movie.rating = @9.6;
    
    [self.movies addObject:movie];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId forIndexPath:indexPath];
    
    Movie *movie = self.movies[indexPath.row];
    
    cell.textLabel.text = movie.name;
    
    return cell;
    
}

@end
