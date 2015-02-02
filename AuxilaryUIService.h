//
//  AuxilaryUIService.h
//  NParks
//
//  Created by Raja Saravanan on 1/31/12.
//  Copyright (c) 2012 Shownearby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor-Expanded.h"
#import "ControllerHeaders.h"

typedef enum{
    nameTag = 12,
    distanceTag,
    mustTryTag
}cellTags;

@interface AuxilaryUIService : NSObject

/*Jump animation For disclaimer view*/
@property (nonatomic, assign) IBOutlet UIView *disclaimerImage;
@property (nonatomic, assign) IBOutlet UIImageView *disclaimerImageView;
@property (nonatomic, assign) IBOutlet UITextView *disclaimerText;
@property (nonatomic, assign) id disclaimerView_Caller;
@property (nonatomic, assign) SEL disclaimerCallback;
-(void)removeDisclaimerView:(id)sender;
-(void)showDisclaimerOn_View:(UIView*)view withTarget:(id)target andSelector:(SEL)selector forText:(NSString*)text_;

#pragma mark -
+(AuxilaryUIService*)auxFunctions;

#pragma mark - Create Category Images && Table Headers
-(UIView *)createCategoryImages:(NSString*)image selectors:(NSArray*)selectrs target:(id)targ imgView:(UIImageView*)imgV;
-(UIView *)getTableHeaderForPlace_Park:(NSDictionary*)details;
-(UIButton*)showMoreBtn:(NSString *)title target:(id)target tag:(NSInteger)whichTag;
-(UILabel*)viewForNoResults:(NSString *)title frame:(CGRect)frame_;
-(UIImageView *)tableHeaderViewWithText:(NSString*)text;

-(UIImageView *)tableHeaderViewWithImag:(NSString*)imageName frame:(CGRect)frame;
-(UIView *)tableHeaderViewWithImag:(NSString*)imageName frame:(CGRect)frame imageframe:(CGRect)imgframe;
-(UIImageView *)tableHeaderViewWithText:(NSString*)text andImag:(NSString*)imageName frame:(CGRect)frame;

-(UIView*)viewForHeaderWith:(UIImage*)image_ frame:(CGRect)frame text:(NSString*)text txtColor:(UIColor*)txtColor font:(CGFloat)font_;

-(UIView*)viewReportDetailHeaderWith:(UIImage*)image_ text:(NSString*)text txtColor:(UIColor*)txtColor font:(UIFont*)font_;

#pragma mark - UIImageView Width and height
+(CGFloat)getHeightOf_2xImage:(NSString*)imageName;
+(CGFloat)getwidthOf_2xImage:(NSString*)imageName;
+(CGFloat)getHeightOf_1xImage:(NSString*)imageName;
+(CGFloat)getwidthOf_1xImage:(NSString*)imageName;

#pragma mark - Table And View Background
+(void)setTableViewImg:(NSString*)imageName table:(UITableView*)table;
+(void)setViewController_BackgroundImg:(NSString*)imageName onView:(UIView*)view;
  
-(UIButton*)detailInfoBtn:(NSString*)img lbl:(NSString*)lbl_Text categoryTag:(int)tag height:(CGRect)fram target:(id)target_ sel:(SEL)selector_;

#pragma mark - TableCell & Label Heights & Lbl Widths
+(CGFloat)getHeightOfTable:(NSString *)maintext subText:(NSString*)subText mainFont:(CGFloat)mF subFont:(CGFloat)sF imgWidth:(CGFloat)imgWid;
+(CGFloat)getHeightOfLabelFor_Text:(NSString *)text andfont:(UIFont*)font andWidthConstraint:(CGFloat)constrainWid;
+(CGFloat)getWidthOfLabelFor_Text:(NSString *)text andfont:(UIFont*)font andHghtConstraint:(CGFloat)constrainHgt;

#pragma mark - TabBarItem
+(UITabBarItem*)getTabBar_ForTitle:(NSString*)title_ andImage:(UIImage*)tabImg withTag:(NSUInteger)tag;

#pragma mark - Cells
-(UITableViewCell*)lifestyleCellWithIdentifier:(NSString*)identifier mainString:(NSString*)mainStr subString:(id)subStr;

#pragma mark - Category Images
-(UIView *)createCategoryImages:(NSString*)image selectors:(NSArray*)selectrs target:(id)targ tagRef:(int)tagv;
+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)frame;

#pragma mark - TextField Creation for your ideas
+(UITextField*)createTextFieldWithFrame:(CGRect)frame tag:(NSInteger)tag andPlaceHolder:(NSString*)placeHolderV selector:(SEL)selector_ withTarget:(id)target borderStyle:(UITextBorderStyle)borderStyl;

#pragma mark - Resign First REsponder
+(void)resignFirst_ResponderForView:(id)view onTarget:(id)target withAction:(SEL)selector;
@end



#pragma mark - CATEGORIES
@interface UINavigationController(completionBarButton)
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated onCompletion:(void(^)(void))callback;
@end

@implementation UINavigationController(completionBarButton)
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated onCompletion:(void(^)(void))callback{
 
    [self pushViewController:viewController animated:animated];
    if (callback) {
        callback();
    }
}
@end


#pragma mark - UITableViewCell Separator Image Categories
@interface UITableViewCell(SeparatorImage)

-(void)custom_CellAccessoryView;
-(void)custom_CellAccessoryViewWithImage:(UIImage *)image;
-(void)separatorLine_ForThisCell;
-(void)separatorLine_ForThisCell_iPad;
-(void)removeSeparator_LineForThisCell;
-(void)removeSeparatorseparatorLineWithOffset;
-(void)separatorLineWithOffset:(CGFloat)offset;
-(void)removeSeparatorColorWithOffset;
//-(void)separatorLine_ForThisCellWithColor:(UIColor *)color height:(NSInteger)height andWidth:(NSInteger)width;
-(void)separatorLine_ForThisCellWithColor:(UIColor *)color height:(NSInteger)height andWidth:(NSInteger)width witXOff:(NSInteger)xOffset;
-(void)separatorLine_ForThisCellWithColor:(UIColor *)color height:(NSInteger)height andWidth:(NSInteger)width witXOff:(NSInteger)xOffset cellHeight:(float) cellHeight;
-(NSIndexPath*)getIndexPath;

@end

#pragma mark - Separator Image Categories
@interface UIImageView(SeparatorImage)

+(UIImageView*)bottomImageView_ForThisViewFrame:(CGRect)thisFrame andImage:(UIImage*)image_;
+(UIImageView*)separatorImageView_ForThisViewFrame:(CGRect)thisFrame;
+(UIImageView*)separatorForThisView:(CGRect)thisFrame withColor:(UIColor*)separtorColor;

@end

#pragma mark - Text Field Resign Categories
@interface UIView(FindAndResignFirstResponder)

- (void)putCellSeparatorImage;
- (void)removeSeperatorImage;
- (void)putCellSeparatorImageOffset:(CGFloat)offset withImg:(UIImage *)img;
- (void)removeSeperatorImageOffset:(CGFloat)offset;
-(void)removeSeparatorColorWithOffsetForView;
-(void)separatorLine_ForThisViewWithColor:(UIColor *)color height:(NSInteger)height andWidth:(NSInteger)width;
- (BOOL)findAndResignFirstResponder;
- (BOOL)findAndResignFirstResponderForTextField;

@end

