//
//  DetailViewController.h
//  Zoo
//
//  Created by Henry Yu on 10-11-09.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Animal;
@interface DetailViewController : UIViewController {
    UIView *mainView;
	Animal *animal;
	UIImageView *imageView;
}

- (void)initAnimal:(Animal *)a;

@end
