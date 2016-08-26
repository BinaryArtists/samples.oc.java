//  DocumentCell.h
//  WebDoc
//
//  Created by Henry Yu on 09-06-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationCell.h"

@interface DocumentCell : ApplicationCell
{
    IBOutlet UIImageView *iconView;
    IBOutlet UILabel *codeLabel;
    IBOutlet UILabel *nameLabel;
}

@end
