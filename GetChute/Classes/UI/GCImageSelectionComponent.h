//
//  GCImageSelectionComponent.h
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCImageSelectionComponent : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSArray *images;
    NSMutableSet *selected;
    IBOutlet UIImageView *selectedIndicator;
    IBOutlet UITableView *imageTable;
}
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) IBOutlet UIImageView *selectedIndicator;

-(NSArray*)selectedImages;

@end