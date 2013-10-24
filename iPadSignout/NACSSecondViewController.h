//
//  NACSSecondViewController.h
//  iPadSignout
//
//  Created by Mark Myers on 11/9/12.
//  Copyright (c) 2012 Napoleon Area City School District. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NACSSecondViewController : UIViewController  <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ZBarReaderDelegate, UIAlertViewDelegate>{
    
    IBOutlet UITextField *conditionText;
    IBOutlet UITextField *dateInText;
    IBOutlet UITextField *invTagText;
    
    UIActionSheet *actionSheet;
    NSString *pickerType;
    
    //    BOOL select;
}

@property (nonatomic,retain) IBOutlet UITextField *conditionText;
@property (nonatomic, retain) IBOutlet UITextField *dateInText;
@property (nonatomic, retain) IBOutlet UITextField *invTagText;

@property (nonatomic, retain) NSArray *arrConditions;

@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) NSString *pickerType;


-(IBAction)conditionBeginEditting:(id)sender;
-(IBAction)scanButtonTapped;
-(IBAction)dateBeginEditting:(id)sender;
-(IBAction)submitTapped;

-(BOOL)textFieldShouldReturn:(UITextField *)textField;
-(void)dateChanged:(id)sender;


@end
