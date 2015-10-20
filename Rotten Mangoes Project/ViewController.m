//
//  ViewController.m
//  Rotten Mangoes Project
//
//  Created by Adam Goldberg on 2015-10-19.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import "ViewController.h"
#import "MovieCollectionViewCell.h"
#import "Movie.h"
#import "DetailViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

//UIBarPositioningDelegate?? Why did I have this?


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) DetailViewController *detailController;


@property (nonatomic, strong) NSMutableArray *movies;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview: self.collectionView];
    
    self.movies = [[NSMutableArray alloc] init];
    
    
    NSString *urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=sr9tdu3checdyayjz85mff8j&page_limit=50";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            NSError *jsonError;
            NSDictionary *movieInformation = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
            
            if (!jsonError) {
//                NSLog(@"movie information: %@", movieInformation);
                
                NSArray *movieArray = movieInformation[@"movies"];
                
                for (NSDictionary *dictionary in movieArray) {
                    Movie *aMovie = [[Movie alloc] init];
                    NSString *imageString = dictionary[@"posters"][@"thumbnail"];
                    
                    
                    //This was what was necessary to change the regular resolution picutre to the high resolution picture!!!! Thanks Ken for the suggestion!!!
                    
                    
//                    NSArray *stringParts = [imageString componentsSeparatedByString:@"/"];
//                    
//                    NSInteger startPoint = [stringParts indexOfObject:@"dkpu1ddg7pbsk.cloudfront.net"];
//                    
//                    NSLog(@" starting point is %ld", startPoint);
//                    
//                    NSInteger arraySize = stringParts.count;
//                    
//                    NSLog(@" count is %ld", arraySize);
//                    
//                    NSRange range = NSMakeRange(startPoint, arraySize-startPoint);
//                    
//                    NSArray *newArray = [stringParts subarrayWithRange:range];
//                    
//                    
//                    NSString *shortImageString = [newArray componentsJoinedByString:@"/"];
//                    
//                    
//                    NSString *prefix =@"https://";
//                    
//                    NSString *highResString = [prefix stringByAppendingString:shortImageString];
//                    
//                    NSLog(@"string is %@", highResString);
//                    
                    
                    
                    
                    
                    
                    
                    
                    
                    NSURL *imageURL = [NSURL URLWithString:imageString];
                    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                    aMovie.movieImage = [UIImage imageWithData:imageData];
                    aMovie.movieTitle = dictionary[@"title"];
                    aMovie.movieRating = dictionary[@"mpaa_rating"];
                    NSInteger year = [dictionary[@"year"] integerValue];
                    NSString *yearString = [NSString stringWithFormat:@"%ld", year];
                    aMovie.movieYear = yearString;
                    NSInteger runtime = [dictionary[@"runtime"] integerValue];
                    NSString *runtimeString = [NSString stringWithFormat:@"%ld", runtime];
                    aMovie.movieRuntime = runtimeString;
                    
                    NSString *partReviewString = dictionary[@"links"][@"reviews"];
                    NSString *reviewString = [partReviewString stringByAppendingString:@"?apikey=sr9tdu3checdyayjz85mff8j&page_limit=3"];
                    aMovie.reviewURL = reviewString;
               
                    
                    
                    [self.movies addObject:aMovie];

                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
                
            }
        }
    }];
    
    [dataTask resume];
   

    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        Movie *theMovie = self.movies[indexPath.row];
        DetailViewController *dvc = (DetailViewController*)[segue destinationViewController];
        [dvc setMovie:theMovie];
        
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.movies.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCell" forIndexPath:indexPath];
    Movie *movie = self.movies[indexPath.row];
    cell.movieImage.image = movie.movieImage;
    
    return cell;
}






@end
