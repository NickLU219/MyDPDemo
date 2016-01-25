//
//  NKMapViewController.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/25.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKMapViewController.h"
#import <MapKit/MapKit.h>
#import "DPAPI.h"
#import "NKDataManager.h"
#import "NKDeal.h"
#import "UIBarButtonItem+NKBarItem.h"
#import "NKAnnotation.h"
#import "NKBusiness.h"

@interface NKMapViewController () <MKMapViewDelegate, DPRequestDelegate>
/**  地图视图 */
@property (nonatomic, strong) MKMapView *mapView;

/**  manager */
@property (nonatomic, strong) CLLocationManager *manager;
/**  编码 */
@property (nonatomic, strong) CLGeocoder *coder;
/**  cityName */
@property (nonatomic, strong) NSString *cityName;
/**  记录请求对象 */
@property (nonatomic, strong) DPRequest *latestRequest;
@end

@implementation NKMapViewController
- (CLGeocoder *)coder {
    if (!_coder) {
        _coder = [[CLGeocoder alloc] init];
    }
    return _coder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.mapView = [[MKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.view addSubview:self.mapView];

    self.manager = [[CLLocationManager alloc] init];
    [self.manager requestWhenInUseAuthorization];

    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:@"icon_back" action:@selector(clickBackItem) target:self];
    self.navigationItem.leftBarButtonItem = backItem;

}

- (void)clickBackItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.coder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        self.cityName = placemark.addressDictionary[@"City"];
        self.cityName = [self.cityName substringToIndex:self.cityName.length];
    }];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (!self.cityName) {
        return;
    }

    DPAPI *api = [DPAPI new];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = self.cityName;
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @1000;

    self.latestRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }

    static NSString *identifier = @"annotation";

    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;

        annotationView.image = ((NKAnnotation *)annotation).image;
    } else {
        annotationView.annotation = annotation;
    }
    return annotationView;
}

#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    if (self.latestRequest != request) {
        return;
    }
    [self.mapView removeAnnotations:self.mapView.annotations];
    NSArray<NKDeal *> *dealArray = [NKDataManager parseDealJson:result];

    for (NKDeal *deal in dealArray) {
        NSArray *businessArray = [NKDataManager getAllBusiness:deal];
        NKCategory *category = [NKDataManager getAllCategory:deal];
        for (NKBusiness *business in businessArray) {
            NKAnnotation *annotation = [NKAnnotation new];
            annotation.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            annotation.title = business.name;
            annotation.subtitle = deal.desc;

            if (category) {
                annotation.image = [UIImage imageNamed:category.map_icon];
            }else {
                NSLog(@"没有图片");
            }
            [self.mapView addAnnotation:annotation];
            
        }
    }
    
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {

}

@end
