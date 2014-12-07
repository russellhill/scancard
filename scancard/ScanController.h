//
//  ScanController.h
//  scancard
//
//  Created by Russell Hill on 07/12/2014.
//  Copyright (c) 2014 Russell Hill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ScanControllerDelegate;

@interface ScanController : UIViewController <AVCaptureMetadataOutputObjectsDelegate> {
	__weak id <ScanControllerDelegate> delegate;
}

@property (nonatomic, weak) id <ScanControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *viewPreview;

@end

@protocol ScanControllerDelegate <NSObject>
- (void)itemScanned:(NSString*)data;
@end