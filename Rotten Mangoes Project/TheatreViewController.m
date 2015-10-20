//
//  TheatreViewController.m
//  Rotten Mangoes Project
//
//  Created by Adam Goldberg on 2015-10-20.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import "TheatreViewController.h"

@import CoreLocation;
@import MapKit;

@interface TheatreViewController () <CLLocationManagerDelegate, MKMapViewDelegate>


@property (strong, nonatomic) IBOutlet MKMapView *theatreMap;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL initialLocationSet;

@property (strong, nonatomic) NSString *apiFullString;








@end

@implementation TheatreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.initialLocationSet = NO;
    self.theatreMap.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
        NSLog(@"status is");
    }
}




-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations firstObject];
    
    if (!self.initialLocationSet) {
        self.initialLocationSet = YES;
        
        MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.04, 0.04));
        [self.theatreMap setRegion:region animated:YES];
        
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            NSLog(@"Placemarks: %@", placemarks);
            
            if (placemarks.count > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                NSLog(@"The Placemark is %@", placemark);
                NSLog(@"The Placemark Postal Code is %@", placemark.postalCode);
                
                
//                NSString *postalCode = placemark.postalCode;
//                NSString *lighthouseApi = @"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=";
//                NSString *movieString = @"&movie=";
//                NSString *stringWithSpaces = [lighthouseApi stringByAppendingString:[postalCode stringByAppendingString:[movieString stringByAppendingString:self.theatreURLString]]];
                
                
                NSString *stringWithSpaces = [NSString stringWithFormat:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie=%@", placemark.postalCode, self.theatreURLString];
                
                self.apiFullString = [stringWithSpaces stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                                      
                
                NSLog(@"Full Movie String: %@", self.apiFullString);
                
                [self loadTheatres];
            }
        }];
       
    }
}


//NSURL *urlReview = [NSURL URLWithString:self.movie.reviewURL];
//
//NSURLSessionDataTask *reviewDataTask = [[NSURLSession sharedSession] dataTaskWithURL:urlReview completionHandler:^(NSData * _Nullable reviewData, NSURLResponse * _Nullable reviewResponse, NSError * _Nullable reviewError) {
//    
//    if (!reviewError) {
//        NSError *jsonReviewError;
//        NSDictionary *reviewInformation = [NSJSONSerialization JSONObjectWithData:reviewData options:0 error:&jsonReviewError];
//        
//        
//        if (!jsonReviewError) {
//            NSLog(@"review information: %@", reviewInformation);
//            
//            NSArray *reviewArray = reviewInformation[@"reviews"];



-(void)loadTheatres
{
    NSURL *urlTheatres = [NSURL URLWithString:self.apiFullString];
    
    NSURLSessionDataTask *theatreDataTask = [[NSURLSession sharedSession] dataTaskWithURL:urlTheatres completionHandler:^(NSData * _Nullable theatreData, NSURLResponse * _Nullable theatreResponse, NSError * _Nullable theatreError) {
        
        if (!theatreError) {
            NSError *jsonTheatreError;
            NSDictionary *theatreInformation = [NSJSONSerialization JSONObjectWithData:theatreData options:0 error:&jsonTheatreError];
            
            if (!jsonTheatreError) {
                NSLog(@"theatre info is %@", theatreInformation);
                
                NSArray *theatres = theatreInformation[@"theatres"];
                
                for (NSDictionary *aTheater in theatres) {
                    
                    MKPointAnnotation *marker = [[MKPointAnnotation alloc] init];
                    marker.coordinate = CLLocationCoordinate2DMake([aTheater[@"lat"] doubleValue], [aTheater[@"lng"] doubleValue]);
                    marker.title = aTheater[@"name"];
                    marker.subtitle = aTheater[@"address"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.theatreMap addAnnotation:marker];
                    });
                
                    
                }
 
            }
        }
    }];

    [theatreDataTask resume];
}


//- (void)loadBikeStations {
//    NSString *jsonPath =[[NSBundle mainBundle] pathForResource:@"bikeStations" ofType:@"json"];
//    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
//    
//    NSError *error = nil;
//    NSDictionary *stationDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
//    if (!error) {
//        NSArray *stations = stationDict[@"stations"][@"station"];
//        for (NSDictionary *station in stations) {
//            
//            MKPointAnnotation *marker = [[MKPointAnnotation alloc] init];
//            
//            marker.coordinate = CLLocationCoordinate2DMake([station[@"lat"] doubleValue], [station[@"long"] doubleValue]);
//            marker.title = station[@"name"];
//            marker.subtitle = station[@"terminalName"];
//            
//            [self.mapView addAnnotation:marker];
//            
//        }
//    }
//}







//         }
//         }];
//         */
//        /*
//         [geocoder geocodeAddressString:@"639 Queen W, Toronto" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//         if (placemarks.count > 0) {
//         CLPlacemark *placemark = [placemarks firstObject];
//         NSLog(@"Placemark: %@", placemark);
//         
//         //placemark.location.coordinate.latitude
//         //placemark.postalCode
//         
//         }
//         }];
//         */
//        
//    }
//}











/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
