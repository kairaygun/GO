//
//  GOBuildTableViewController.m
//  unit-1-final-project
//
//  Created by Jamaal Sedayao on 8/28/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "GOBuildTableViewController.h"

@interface GOBuildTableViewController ()

@property (nonatomic) BuildManager * workoutsData;
@property (weak, nonatomic) IBOutlet UIButton *finishWorkoutButton;

@property (nonatomic) int checkedWorkouts;

@end

@implementation GOBuildTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.checkedWorkouts = 0;
    self.finishWorkoutButton.hidden = YES;

    
    self.workoutsData = [BuildManager sharedInstance];
    [self.workoutsData initializeModel];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.workoutsData.workoutList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoBuildIdentifier"];
    
    if (!cell){
        cell = [[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoBuildIdentifier"];
    }
    
    BuildWorkout *thisWorkout = [self.workoutsData.workoutList objectAtIndex:indexPath.row];
    
    
    cell.workoutNameLabel.text = thisWorkout.exerciseName;
    cell.setLabel.text = [NSString stringWithFormat:@"%ld sets",(long)thisWorkout.sets];
    cell.repLabel.text = [NSString stringWithFormat:@"%ld reps",(long)thisWorkout.reps];
    cell.weightLabel.text = [NSString stringWithFormat:@"%ld lbs",(long)thisWorkout.weight];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.workoutsData.workoutList removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *tableCell = [tableView cellForRowAtIndexPath:indexPath];
    BOOL isSelected = (tableCell.accessoryType == UITableViewCellAccessoryCheckmark);
    
    if (isSelected) {

        tableCell.accessoryType = UITableViewCellAccessoryNone;
        self.checkedWorkouts -= 1;

        
    }
    else {
        tableCell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSLog (@"selected: %ld", (long)indexPath.row);
        self.checkedWorkouts += 1;
    }
    NSLog(@"checked workouts: %d", self.checkedWorkouts);
    
    if (self.checkedWorkouts == self.workoutsData.workoutList.count){
        self.finishWorkoutButton.hidden = NO;
        NSLog(@"YES!");
    } else {
        self.finishWorkoutButton.hidden = YES;
    }
    
}
- (void) viewDidAppear:(BOOL)animated{
    
    [self.tableView reloadData];
}
- (void) viewWillAppear:(BOOL)animated{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
}
- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)finishWorkoutPressed:(UIButton *)sender {
    
    self.workoutsData.workoutList = nil;
    self.finishWorkoutButton.hidden = YES;
    self.checkedWorkouts = 0;
    
    [self.tableView reloadData];
   
    [self Back];
    
    NSLog(@"checked workouts: %d", self.checkedWorkouts);
}



@end
