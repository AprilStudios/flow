
#import "APRLoginViewController.h"



@interface APRLoginViewController ()

@property (nonatomic, weak) IBOutlet UIButton *toMainButton;

@end
#pragma mark -


@implementation APRLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"??");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)toMain:(id)sender
{
    // Get the storyboard named secondStoryBoard from the main bundle:
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainVC"];
    
    // Then push the new view controller in the usual way:
    [self presentViewController:mainVC animated:YES completion:NULL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
