//
//  ImagePicker.h
//  BikeThere-Tabs
//
//  Created by Greg Lind on 12/11/10.
//  Copyright 2010 Metro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imagePicker : UIViewController  <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
	
	UIBarButtonItem *cameraButton;
	UIButton *button;
	
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cameraButton;

- (IBAction)takePicture:(id)sender;
@end
