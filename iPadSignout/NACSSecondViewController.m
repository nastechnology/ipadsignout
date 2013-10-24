//
//  NACSSecondViewController.m
//  iPadSignout
//
//  Created by Mark Myers on 11/9/12.
//  Copyright (c) 2012 Napoleon Area City School District. All rights reserved.
//

#import "NACSSecondViewController.h"

@interface NACSSecondViewController ()

@end

@implementation NACSSecondViewController

@synthesize conditionText, dateInText, invTagText,actionSheet,pickerType;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.arrConditions = [NSArray arrayWithObjects:@"",@"Good",@"Fair",@"Poor", nil];
    
    // Condition Picker
    UIPickerView *conditionPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    conditionPicker.delegate = self;
    conditionPicker.dataSource = self;
    [conditionPicker setShowsSelectionIndicator:YES];
    conditionText.inputView = conditionPicker;
    
    // Create done button in UIPickerView
    UIToolbar*  mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [mypickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    
    [barItems addObject:doneBtn];
    [mypickerToolbar setItems:barItems animated:YES];
    
    conditionText.inputAccessoryView = mypickerToolbar;
    invTagText.inputAccessoryView = mypickerToolbar;


    // DatePicker Stuff
    UIDatePicker *dateInPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    dateInPicker.datePickerMode = UIDatePickerModeDate;
    [dateInPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    dateInText.inputView = dateInPicker;
    dateInText.inputAccessoryView = mypickerToolbar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pickerDoneClicked
{
    //    NSLog(@"Done Clicked: %@",self.pickerType);
    if([self.pickerType isEqualToString:@"condition"]){
        [conditionText resignFirstResponder];
    }else if([self.pickerType isEqualToString:@"inventory"]){
        [invTagText resignFirstResponder];
    } else {
        [dateInText resignFirstResponder];
    }
    pickerType = @"";
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //    NSLog(@"Picker Number of Rows: %@",self.pickerType);
    return self.arrConditions.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //    NSLog(@"Picker Title Row: %@",self.pickerType);
    return [self.arrConditions objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //    NSLog(@"Picker Clicked: %@",self.pickerType);
    conditionText.text = (NSString *)[self.arrConditions objectAtIndex:row];
}

#pragma mark - PickerPressedState

-(IBAction)conditionBeginEditting:(id)sender{
    self.pickerType = @"condition";
    //     NSLog(@"Picker Clicked: condition");
}

#pragma mark - DatePicker
-(void)dateChanged:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    dateInText.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:picker.date]];
}

-(IBAction)dateBeginEditting:(id)sender{
    self.pickerType = @"dateIn";
}

#pragma mark - ZBar Integration
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
	[info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
	
    // EXAMPLE: do something useful with the barcode data
	NSString *ticketId = symbol.data;
    
    invTagText.text = ticketId;
	
    
    
	
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    //    [reader dismissModalViewControllerAnimated: YES];
    [reader dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction) scanButtonTapped
{
    self.pickerType = @"inventory";
	// ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
	
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
	
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
				   config: ZBAR_CFG_ENABLE
					   to: 0];
	
    // present and release the controller
    [self presentModalViewController: reader
							animated: YES];
}

- (IBAction)submitTapped{
    NSString *urlString = @"http://api.napoleonareaschools.org/ipadsignout/checkin";
    NSLog(@"The URL: %@",urlString);
    NSString *invTag = invTagText.text;
    NSString *conditionIn = conditionText.text;
    NSString *dateTo = dateInText.text;
    
    NSDictionary *submitData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                invTag,@"inv_tag",
                                conditionIn,@"conditionin",
                                dateTo,@"date_to",
                                nil];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:submitData options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"JSON DATA: %@", jsonData);
    NSURL *loadingUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:loadingUrl];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:jsonData];
    
	NSURLResponse *theResponse = [[NSURLResponse alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&error];
    
//    NSLog(@"NSData : %@", data);
    
    if(error) {
    	// handle error
//    	NSLog(@"Error: %@", error);
        NSString *returnStr = [NSString stringWithFormat:@"Error on checkin: %@", error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:returnStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
    	
    	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//        NSLog(@"The response: %@",jsonDict);
        if(error){
            //NSString *name = [jsonDict objectForKey:@"name"];
            NSString *returnStr = [NSString stringWithFormat:@"Error on checkin: %@", [jsonDict objectForKey:@"error"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:returnStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            //NSString *name = [jsonDict objectForKey:@"name"];
            NSString *returnStr = [NSString stringWithFormat:@"iPad/Cart has been checked-in with invetory number: %@", invTag];
            NSString *title = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"title"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:returnStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    invTagText.text = @"";
//    conditionText.text = @"";
//    dateInText.text = @"";
    [self viewDidLoad];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}


@end
