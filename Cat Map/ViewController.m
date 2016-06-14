//
//  ViewController.m
//  Cat Map
//
//  Created by Bao Tran on 6/12/16.
//  Copyright © 2016 Bao Tran. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) MKMapView *mapView; // Object that provides you the map view.
@property (nonatomic, strong) CLLocationManager *locationManager; // Object that provides you the location data.
// NSLocationAlwaysUsageDescription OR NSLocationWhenInUseUsageDescription needs to be added to info.plist with NSString "Location is required"

- (IBAction)getlocation:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self mapViewInstantiate];
    [self instantiateSearchBar];
    self.view.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:123.0f/255.0f blue:70.0f/255.0f alpha:1.f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Instantiate Views

- (void)mapViewInstantiate {
    
    UIEdgeInsets padding = UIEdgeInsetsMake(80, 20, 200, 20);

    //    self.mapView = [[MKMapView alloc] initWithFrame:[self.view frame]]; // This set MKMapView instance to fill self.view
    
    self.mapView = [[MKMapView alloc] init];
    [self.view addSubview: self.mapView];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];
    
    self.mapView.delegate = self;
    
}

- (void)locationInstantiate {
    
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.locationManager.distanceFilter = 100;
    
    [self.locationManager requestWhenInUseAuthorization];
    
//    [self.locationManager startMonitoringSignificantLocationChanges];
    
//    [CLLocationManager locationServicesEnabled]; // is this required?
    
    [[self mapView] setShowsUserLocation:YES];
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)instantiateSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    
    [self.view addSubview:searchBar];

    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.view.mas_leading).with.offset(20);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-20);
        make.top.equalTo(self.view.mas_top).with.offset(30);
        make.height.mas_equalTo(50);

    }];
    
    searchBar.tintColor = [UIColor colorWithRed:255.0f/255.0f green:75.0f/255.0f blue:10.0f/255.0f alpha:1.0f];
    searchBar.barTintColor = [UIColor colorWithRed:28.0f/255.0f green:28.0f/255.0f blue:28.0f/255.0f alpha:1.0f];
    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    searchField.backgroundColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    searchField.textColor = searchBar.tintColor;
}

- (IBAction)getlocation:(id)sender {
    [self locationInstantiate];
    
}

//-(void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self applyMapViewMemoryFix];
//}
//
//// Testing to see if this method fixes the possible memory leak
//- (void)applyMapViewMemoryFix {
//    
//    switch (self.mapView.mapType) {
//            
//        case MKMapTypeHybrid:
//        {
//            self.mapView.mapType = MKMapTypeStandard;
//        }
//            break;
//        case MKMapTypeStandard:
//        {
//            self.mapView.mapType = MKMapTypeHybrid;
//        }
//            break;
//        default:
//            break;
//    }
//    
//    self.mapView.showsUserLocation = NO;
//    self.mapView.delegate = nil;
//    [self.mapView removeFromSuperview];
//    self.mapView = nil;
//}

#pragma mark - <CLLocationManagerDelegate> Core Location Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"Failed to get your location" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    UIAlertAction *continueButton = [UIAlertAction actionWithTitle:@"continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:continueButton];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSLog(@"\nlocations: %@\n\n", locations);
    NSLog(@"\nlocation: %@\n\n", location);
    
    
}

#pragma mark - <MKMapViewDelegate> MapKit delegate methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    
    CLLocationCoordinate2D location;
    location.latitude = userLocation.location.coordinate.latitude;
    location.longitude = userLocation.location.coordinate.longitude;
    
    region.span = span;
    region.center = location;
    
    [self.mapView setRegion:region animated:YES];
}

@end
