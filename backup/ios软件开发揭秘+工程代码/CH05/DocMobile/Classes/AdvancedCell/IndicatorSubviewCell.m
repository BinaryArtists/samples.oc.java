//
//  IndicatorSubviewCell.m
//  WebDoc
//
//  Created by Henry Yu on 09-06-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "IndicatorSubviewCell.h"


@implementation IndicatorSubviewCell

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];

    iconView.backgroundColor = backgroundColor;
    nameLabel.backgroundColor = backgroundColor;
    priceLabel.backgroundColor = backgroundColor;
}

- (void)setIcon:(UIImage *)newIcon
{
    [super setIcon:newIcon];
    iconView.image = newIcon;
}

- (void)setId:(NSString *)newId
{
    [super setId:newId];
    Id = newId;
}

- (void)setName:(NSString *)newName
{
    [super setName:newName];
    nameLabel.text = newName;
}

- (void)setState:(NSString *)state
{
    [super setState:state];
    ActualState = state;
}

- (void)setDescription:(NSString *)desc
{
    [super setState:desc];
    Description = desc;
}

- (void)setValue:(NSString *)newValue
{
    [super setValue:newValue];
    priceLabel.text = newValue;
}

- (void)dealloc
{
    [iconView release];
    [nameLabel release];
    [priceLabel release];
    [super dealloc];
}

@end
