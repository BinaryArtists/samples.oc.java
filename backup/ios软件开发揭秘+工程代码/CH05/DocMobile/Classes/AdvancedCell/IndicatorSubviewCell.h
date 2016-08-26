//
//  IndicatorSubviewCell.h
//  WebDoc
//
//  Created by Henry Yu on 09-06-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndicatorCell.h"


@interface IndicatorSubviewCell : IndicatorCell
{
    IBOutlet UIImageView *iconView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *priceLabel;	
}

@end
