//
//  GHHViewController.m
//  geek hub hello world
//
//  Created by av_tehnik on 10/11/13.
//  Copyright (c) 2013 vitaliy pitvalo. All rights reserved.
//

#import "GHHViewController.h"
#import "GHHViewPodcastController.h"

@interface GHHViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GHHViewController

//@synthesize podcasts;


- (void)viewDidLoad
{
    self.podcasts = [[NSArray alloc] initWithObjects:@"UWP",@"Radio T",@"SitePoint",@"Laowai cast", nil];

    NSLog(@"GHHViewController");
    self.title = @"PodCasts";
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"podcast";
    //here you check for PreCreated cell.
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        NSLog(@"cell is nill");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    
    
    cell.textLabel.text = [self.podcasts objectAtIndex:indexPath.row];
    
    return cell;
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog( @"view name %i ", self.podcasts.count);
    return self.podcasts.count;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"can edit?");
    // Detemine if it's in editing mode
    if (self.tableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    UIViewController *DVC = [segue destinationViewController];
    
    
    NSString *viewName = NSStringFromClass([DVC class]);
    NSLog( @"view name %@ ", viewName);
    
    
    if([viewName isEqualToString:@"GHHManageFeedsViewController"]){
        
    }else{
        DVC.title = [self.podcasts objectAtIndex:path.row];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"delete");
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.podcasts];
    [mutableArray removeObject:[self.podcasts objectAtIndex:indexPath.row]];
    self.podcasts = [NSArray arrayWithArray:mutableArray];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];

}


- (IBAction)editTableAction:(id)sender {
    
    if (self.tableView.editing)
    {
        //[self.tableView setEditing:NO animated:YES];
    }else{
        // [self.tableView setEditing:YES animated:YES];
    }
    
    
}

@end
