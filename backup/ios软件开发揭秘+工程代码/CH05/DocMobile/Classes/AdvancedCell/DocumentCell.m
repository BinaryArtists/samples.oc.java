//
//  DocumentCell.m
//  WebDoc
//
//  Created by Henry Yu on 09-06-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "DocumentCell.h"


@implementation DocumentCell

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];

    iconView.backgroundColor = backgroundColor;
    codeLabel.backgroundColor = backgroundColor;
    nameLabel.backgroundColor = backgroundColor;    
}

- (void)setIcon:(UIImage *)newIcon
{
    [super setIcon:newIcon];
    iconView.image = newIcon;
}

- (void)setCode:(NSString *)newCode
{
    [super setCode:newCode];
    codeLabel.text = newCode;
	codeLabel.lineBreakMode = UILineBreakModeWordWrap;
	codeLabel.numberOfLines = 0;
	//codeLabel.textColor = [UIColor lightTextColor]; 
    
}

- (void)setName:(NSString *)newName
{
    [super setName:newName];
    nameLabel.text = newName;
	nameLabel.lineBreakMode = UILineBreakModeWordWrap;
	nameLabel.numberOfLines = 0;
}


- (void)dealloc
{
    [iconView release];
    [codeLabel release];
    [nameLabel release];    

    [super dealloc];
}

@end
