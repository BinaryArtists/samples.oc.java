//
//  IndicatorCell.m
//  WebDoc
//
//  Created by Henry Yu on 09-06-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "IndicatorCell.h"

@implementation IndicatorCell

@synthesize useDarkBackground, icon, Id, Name,Description,Value,ActualState;

- (void)setUseDarkBackground:(BOOL)flag
{
    //if (flag != useDarkBackground || !self.backgroundView)
	if(0)
    {
        useDarkBackground = flag;

        NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:useDarkBackground ? @"DarkBackground" : @"LightBackground" ofType:@"png"];
        UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
        self.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.frame = self.bounds;
    }
}

- (void)setState:(NSString *)state
{
    ActualState = state;
}

- (void)setDescription:(NSString *)str
{
    Description = str;
}

- (void)dealloc
{
    [icon release];	
    [Id release];
 	[ActualState release];
    [super dealloc];
}

@end
