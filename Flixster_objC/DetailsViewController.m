//
//  DetailsViewController.m
//  Flixster_objC
//
//  Created by Makayla Rodriguez on 5/15/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = _detailDict[@"title"];
    self.synopsisLabel.text = _detailDict[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *fullPosterUrl = [baseURLString stringByAppendingString:_detailDict[@"poster_path"]];
    
    NSURL *posterUrl = [NSURL URLWithString:fullPosterUrl];
    
    [self.posterView setImageWithURL:posterUrl];
    
    NSString *baseBackdropURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *fullBackgroundUrl = [baseBackdropURLString stringByAppendingString:_detailDict[@"backdrop_path"]];
    
    NSURL *backdropUrl = [NSURL URLWithString:fullBackgroundUrl];
    
    [self.backdropView setImageWithURL:backdropUrl];
    
    NSLog(@"Detail screen");
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
