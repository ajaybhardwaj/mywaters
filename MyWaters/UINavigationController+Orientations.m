//
//  UINavigationController+Orientations.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 1/11/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import "UINavigationController+Orientations.h"

@implementation UINavigationController (Orientations)

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
