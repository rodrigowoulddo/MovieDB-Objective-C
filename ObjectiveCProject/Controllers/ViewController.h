//
//  ViewController.h
//  ObjectiveCProject
//
//  Created by Rodrigo Giglio on 16/03/20.
//  Copyright © 2020 Rodrigo Giglio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController
<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

