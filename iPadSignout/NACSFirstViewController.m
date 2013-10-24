//
//  NACSFirstViewController.m
//  iPadSignout
//
//  Created by Mark Myers on 11/9/12.
//  Copyright (c) 2012 Napoleon Area City School District. All rights reserved.
//

#import "NACSFirstViewController.h"


@interface NACSFirstViewController ()

@end

@implementation NACSFirstViewController

@synthesize nameText, buildingText, conditionText, dateOutText, actionSheet,pickerType, invTagText;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.arrBuildings = [NSArray arrayWithObjects:@"",@"CDB",@"WES",@"CES",@"NMS",@"NHS", nil];
    self.arrConditions = [NSArray arrayWithObjects:@"",@"Good",@"Fair",@"Poor", nil];
    
    
    // Condition Picker
    UIPickerView *conditionPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    conditionPicker.delegate = self;
    conditionPicker.dataSource = self;
    [conditionPicker setShowsSelectionIndicator:YES];
    conditionText.inputView = conditionPicker;
    
    // Building Picker
    UIPickerView *buildingPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    buildingPicker.delegate = self;
    buildingPicker.dataSource = self;
    [buildingPicker setShowsSelectionIndicator:YES];
    buildingText.inputView = buildingPicker;

    
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
    buildingText.inputAccessoryView = mypickerToolbar;
    nameText.inputAccessoryView = mypickerToolbar;
    invTagText.inputAccessoryView = mypickerToolbar;
    
    // DatePicker Stuff
    UIDatePicker *dateOutPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    dateOutPicker.datePickerMode = UIDatePickerModeDate;
    [dateOutPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    dateOutText.inputView = dateOutPicker;
    dateOutText.inputAccessoryView = mypickerToolbar;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pickerDoneClicked
{
//    NSLog(@"Done Clicked: %@",self.pickerType);
    if([self.pickerType isEqualToString:@"building"]){
        [buildingText resignFirstResponder];
    } else if([self.pickerType isEqualToString:@"condition"]){
        [conditionText resignFirstResponder];
    } else if([self.pickerType isEqualToString:@"name"]){
        [nameText resignFirstResponder];
    } else if([self.pickerType isEqualToString:@"inventory"]){
        [invTagText resignFirstResponder];
    } else {
        [dateOutText resignFirstResponder];
    }
    pickerType = @"";
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    NSLog(@"Picker Number of Rows: %@",self.pickerType);
    if([pickerType isEqualToString:@"building"]){
        return self.arrBuildings.count;
    } else {
        return self.arrConditions.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSLog(@"Picker Title Row: %@",self.pickerType);
    if([self.pickerType isEqualToString:@"building"]){
        return [self.arrBuildings objectAtIndex:row];
    } else {
        return [self.arrConditions objectAtIndex:row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    NSLog(@"Picker Clicked: %@",self.pickerType);
    if([self.pickerType isEqualToString:@"building"]){
        buildingText.text = (NSString *)[self.arrBuildings objectAtIndex:row];
    } else {
        conditionText.text = (NSString *)[self.arrConditions objectAtIndex:row];
    }
}

#pragma mark - PickerPressedState

-(IBAction)conditionBeginEditting:(id)sender{
    self.pickerType = @"condition";
//     NSLog(@"Picker Clicked: condition");
}

-(IBAction)buildingBeginEditting:(id)sender {
    self.pickerType = @"building";
//     NSLog(@"Picker Clicked: building"); 
}

-(IBAction)nameBeginEditting:(id)sender {
    self.pickerType = @"name";
    //     NSLog(@"Picker Clicked: building");
}

#pragma mark - DatePicker
-(void)dateChanged:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"]; 
    
    dateOutText.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:picker.date]];
}

-(IBAction)dateBeginEditting:(id)sender{
    self.pickerType = @"dateOut";
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
    	NSString *urlString = @"http://api.napoleonareaschools.org/ipadsignout/signout";
    	NSLog(@"The URL: %@",urlString);
    NSString *name = nameText.text;
    NSString *invTag = invTagText.text;
    NSString *building = buildingText.text;
    NSString *conditionOut = conditionText.text;
    NSString *dateFrom = dateOutText.text;
    
    NSInteger *rNumber = arc4random();
    
    NSString *guid = [self md5:[NSString stringWithFormat:@"%@%@%d", invTag, dateFrom, rNumber]];
    
    NSDictionary *submitData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    name, @"name",
                                    invTag, @"inv_tag",
                                    building,@"building",
                                    conditionOut,@"condition_out",
                                    dateFrom,@"date_from",
                                    guid,@"guid",
                                nil];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:submitData options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"JSON STRING: %@", jsonData);
    NSURL *loadingUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:loadingUrl];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    
	NSURLResponse *theResponse = [[NSURLResponse alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&error];
    
    if(error) {
    	// handle error
    	NSLog(@"Error: %@", error);
    } else {
    	NSError *jsonError = nil;
    	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if(jsonError){
            NSString *returnStr = [NSString stringWithFormat:@"Error on checkin: %@", [jsonDict objectForKey:@"error"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:returnStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            NSString *returnStr = [NSString stringWithFormat:@"%@ has checked out iPad/Cart with invetory number: %@", name, invTag];
            NSString *title = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"title"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:returnStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    nameText.text = @"";
//    invTagText.text = @"";
//    buildingText.text = @"";
//    conditionText.text = @"";
//    dateOutText.text = @"";
    [self viewWillDisappear:YES];
    [self viewWillAppear:YES];
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//    return NO;
//}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end
