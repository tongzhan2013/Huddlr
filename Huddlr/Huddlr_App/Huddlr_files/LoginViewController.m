//

#import "LoginViewController.h"
#import "UserDetailsViewController.h"
#import <Parse/Parse.h>

@implementation LoginViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Facebook Profile";
    
    // Check if user is cached and linked to Facebook, if so, bypass login    
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        //[self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:NO];
    }
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Login_background.png"]]];

}


#pragma mark - Login methods

/* Login to facebook method */
- (IBAction)loginButtonTouchHandler:(id)sender  {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Facebook login cancelled. Please try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"An error occurred. Please try again."delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        }
        
        else {
            if (user.isNew) {NSLog(@"User with facebook signed up and logged in!");}
            else {NSLog(@"User with facebook logged in!");}
            
            // Save the current user's Facebook ID and name on Parse for future query
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSString *fbId=[result objectForKey:@"id"];
                    [user setObject:fbId forKey:@"fbId"];
                    
                    NSURL *nameURL=[[NSURL alloc]initWithString:[NSString stringWithFormat: @"https://graph.facebook.com/%@?fields=name",fbId]];
                    NSString *content=[[NSString alloc]initWithContentsOfURL:nameURL encoding:NSUTF8StringEncoding error:NULL];
                    NSArray *components=[content componentsSeparatedByString:@"\""];
                    NSString *nameStr=[components objectAtIndex:3];
                    [[NSUserDefaults standardUserDefaults]setObject:nameStr forKey:@"name"];
                    [user setObject:nameStr forKey:@"name"];
                    [user saveInBackground];
                }
            }];

            // Get the user's FB friend IDs and save the array to NSUserDefaults
            [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // Result will contain an array with your user's friends in the "data" key
                    NSArray *friendObjects = [result objectForKey:@"data"];
                    NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
                    // Create a list of friends' Facebook IDs
                    for (NSDictionary *friendObject in friendObjects) {
                        [friendIds addObject:[friendObject objectForKey:@"id"]];
                    }
                    [[NSUserDefaults standardUserDefaults]setObject:friendIds forKey:@"friendIds"];
                }
            }];

            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished

}



@end
