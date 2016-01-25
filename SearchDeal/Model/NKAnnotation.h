//
//  NKAnnotation.h
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/25.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NKAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


/**  图片 */
@property (nonatomic, strong) UIImage *image;


@end
