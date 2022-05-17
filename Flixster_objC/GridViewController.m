//
//  GridViewController.m
//  Flixster_objC
//
//  Created by Makayla Rodriguez on 5/16/22.
//

#import "GridViewController.h"
#import "MovieGridCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"


@interface GridViewController ()<UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *moviesCollectionView;
@property (nonatomic, strong) NSArray *moviesArray;
@property (strong, nonatomic) NSArray *filteredData;


@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.moviesCollectionView.dataSource = self;
    
    [self fetchMovies];
}

- (void)fetchMovies {
    
    self.filteredData = self.moviesArray;
    
    UIAlertController *networkAlert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self fetchMovies];
        }];
    // add the tryAgainAction action to the alertController
    [networkAlert addAction:tryAgainAction];

            
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=3434be17b7e2f47a93a211477a193c7e"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               // UIAlertController
               [self presentViewController:networkAlert animated:YES completion:^{
                   // optional code for what happens after the alert controller has finished presenting
               }];
               
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               // logging the array of movies
               NSLog(@"%@", dataDictionary);
               
               // TODO: Get the array of movies
               self.moviesArray = dataDictionary[@"results"];
               self.filteredData = dataDictionary[@"results"];
               
               [self.moviesCollectionView reloadData];
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
       }];
    [task resume];
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieGridCell" forIndexPath:indexPath];

    
    NSDictionary *movie = self.filteredData[indexPath.row];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *fullPosterUrl = [baseURLString stringByAppendingString:movie[@"poster_path"]];
    
    NSURL *posterUrl = [NSURL URLWithString:fullPosterUrl];
    
    [cell.posterView setImageWithURL:posterUrl];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *cell = sender;
    NSIndexPath *myIndexPath = [self.moviesCollectionView indexPathForCell:cell];

    NSDictionary *dataToPass = self.filteredData[myIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}

@end
