//
//  Movie.h
//  Rotten Mangoes Project
//
//  Created by Adam Goldberg on 2015-10-19.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Movie : NSObject

@property (nonatomic, strong) UIImage *movieImage;

@property (nonatomic, strong) NSString *movieTitle;

@property (nonatomic, strong) NSString *movieRating;

@property (nonatomic, strong) NSString *movieRuntime;

@property (nonatomic, strong) NSString *movieYear;

@property (nonatomic, strong) NSString *reviewURL;

@property (nonatomic, strong) NSString *movieReview;

@end
