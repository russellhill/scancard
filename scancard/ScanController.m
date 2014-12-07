//
//  ScanController.m
//  scancard
//
//  Created by Russell Hill on 07/12/2014.
//  Copyright (c) 2014 Russell Hill. All rights reserved.
//

#import "ScanController.h"

@interface ScanController ()

@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

- (BOOL)startReading;
- (void)stopReading;

@end

@implementation ScanController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_isReading = false;
	_captureSession = nil;
	
	[self startReading];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self stopReading];
}

- (BOOL)startReading {
	NSError *error;
	
	AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
	if (!input) {
		NSLog(@"%@", [error localizedDescription]);
		return NO;
	}
	
	_captureSession = [[AVCaptureSession alloc] init];
	[_captureSession addInput:input];
	
	AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
	[_captureSession addOutput:captureMetadataOutput];
	
	dispatch_queue_t dispatchQueue;
	dispatchQueue = dispatch_queue_create("myQueue", NULL);
	[captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
	[captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, nil]];
	
	_videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
	[_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	[_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
	[_viewPreview.layer addSublayer:_videoPreviewLayer];
	
	[_captureSession startRunning];
	
	return YES;
}

- (void)scanComplete:(NSString*)data {
	NSLog(@"HERE: %@", data);

	[self stopReading];

	if ([_delegate respondsToSelector:@selector(itemScanned:)]) {
		[_delegate itemScanned:data];
	}
}

- (void)stopReading {
	[_captureSession stopRunning];
	_captureSession = nil;
	
	[_videoPreviewLayer removeFromSuperlayer];
	_isReading = NO;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
	if (metadataObjects != nil && [metadataObjects count] > 0) {
		AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
		if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode] || [[metadataObj type] isEqualToString:AVMetadataObjectTypeEAN13Code] || [[metadataObj type] isEqualToString:AVMetadataObjectTypeEAN8Code]) {
			NSLog(@"data: %@",[metadataObj stringValue]);
			[self performSelectorOnMainThread:@selector(scanComplete:) withObject:[metadataObj stringValue] waitUntilDone:NO];
		} else {
			NSLog(@"other: %@",[metadataObj type]);
		}
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
