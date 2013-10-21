//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController : UIViewController <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)loginButtonTouchHandler:(id)sender;

@property (nonatomic,copy) NSString *objectId;



@end
