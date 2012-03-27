//
//  ORImageViewCell.m
//  Puttio
//
//  Created by orta therox on 27/03/2012.
//  Copyright (c) 2012 ortatherox.com. All rights reserved.
//

#import "ORImageViewCell.h"

static UIEdgeInsets ContentInsets = {.top = 10, .left = 6, .right = 6, .bottom = 5};

static CGFloat TitleLabelHeight = 20;
static CGFloat SubTitleLabelHeight = 24;

static CGFloat ImageBottomMargin = 10;
static CGFloat TitleBottomMargin = 1;


@implementation ORImageViewCell

@synthesize image;
@synthesize imageURL;
@synthesize subtitle = _subtitle;
@synthesize title = _title;
@synthesize item = _item;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)identifier {
    if (self = [super initWithFrame:frame reuseIdentifier:identifier]) {
        UIColor *black = [UIColor blackColor];
        
        self.accessoryPosition = KKGridViewCellAccessoryPositionTopLeft;
        self.selectedBackgroundView = [[UIView alloc] init];
        self.opaque = NO;
        self.contentView.backgroundColor = [UIColor purpleColor];
        self.backgroundView.backgroundColor = [UIColor redColor];
        self.contentView.opaque = NO;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = black;
        imageView.opaque = NO;
        
        CGRect frame = imageView.frame;
        
        frame.size.width = CGRectGetWidth(self.frame) - ContentInsets.left - ContentInsets.right;
        frame.size.height = CGRectGetHeight(self.frame) - ContentInsets.bottom - ContentInsets.top;
        frame.origin.x = ContentInsets.left;
        frame.origin.y = ContentInsets.top;
        imageView.frame = frame;
        [self.contentView addSubview:imageView];
        
		activityIndicatorView = 
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityIndicatorView sizeToFit];
        [self.contentView addSubview:activityIndicatorView];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor blueColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.backgroundColor = black;
        titleLabel.opaque = NO;
        titleLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:titleLabel];
        
        subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.textColor = [UIColor redColor];
        subtitleLabel.textAlignment = UITextAlignmentCenter;
        subtitleLabel.backgroundColor = black;
        subtitleLabel.opaque = NO;
        [self.contentView addSubview:subtitleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (imageView.image) {
        [activityIndicatorView stopAnimating];
        activityIndicatorView.frame = CGRectZero;
    }
    else {
        [activityIndicatorView stopAnimating];
        [activityIndicatorView sizeToFit];
        activityIndicatorView.center = imageView.center;
    }
    if ([_title length]) {
        titleLabel.frame = CGRectMake(ContentInsets.left, 
                                      CGRectGetMaxY(imageView.frame) + ImageBottomMargin, 
                                      CGRectGetWidth(self.bounds) - ContentInsets.left - ContentInsets.right, 
                                      TitleLabelHeight);        
    }
    else {
        titleLabel.frame = CGRectMake(ContentInsets.left, 
                                      CGRectGetMaxY(imageView.frame) + ImageBottomMargin, 
                                      CGRectGetWidth(self.bounds) - ContentInsets.left - ContentInsets.right, 
                                      0);
    }
    subtitleLabel.frame = CGRectMake(ContentInsets.left, 
                                     CGRectGetMaxY(titleLabel.frame) + TitleBottomMargin, 
                                     CGRectGetWidth(self.bounds) - ContentInsets.left - ContentInsets.right, 
                                     SubTitleLabelHeight);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    titleLabel.text = [title uppercaseString];
}

- (void)setSubtitle:(NSString *)subtitle{
    _subtitle = subtitle;
    subtitleLabel.text = _subtitle;
}

@end
