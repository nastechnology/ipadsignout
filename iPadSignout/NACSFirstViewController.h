//
//  NACSFirstViewController.h
//  iPadSignout
//
//  Created by Mark Myers on 11/9/12.
//  Copyright (c) 2012 Napoleon Area City School District. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>


@interface NACSFirstViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ZBarReaderDelegate, UIAlertViewDelegate>{
    
    IBOutlet UITextField *nameText;
    IBOutlet UITextField *buildingText;
    IBOutlet UITextField *dateOutText;
    IBOutlet UITextField *invTagText;
    
    UIActionSheet *actionSheet;
    NSString *pickerType;
    
//    BOOL select;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic,retain) IBOutlet UITextField *nameText;
@property (nonatomic,retain) IBOutlet UITextField *buildingText;
@property (nonatomic,retain) IBOutlet UITextField *conditionText;
@property (nonatomic, retain) IBOutlet UITextField *dateOutText;
@property (nonatomic, retain) IBOutlet UITextField *invTagText;
@property (nonatomic, retain) NSArray *arrBuildings;
@property (nonatomic, retain) NSArray *arrConditions;

@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) NSString *pickerType;


//@property (nonatomic, retain) IBOutlet UIToolbar *accessoryView;
//@property (nonatomic, retain) IBOutlet UIDatePicker *date1Picker;

-(IBAction)conditionBeginEditting:(id)sender;
-(IBAction)buildingBeginEditting:(id)sender;
- (IBAction) scanButtonTapped;
-(IBAction)dateBeginEditting:(id)sender;
-(IBAction)nameBeginEditting:(id)sender;
-(IBAction)submitTapped;

-(BOOL)textFieldShouldReturn:(UITextField *)textField;
-(void)dateChanged:(id)sender;
- (NSString *) md5:(NSString *) input;



@end
