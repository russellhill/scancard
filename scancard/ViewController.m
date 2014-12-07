//
//  ViewController.m
//  scancard
//
//  Created by Russell Hill on 07/12/2014.
//  Copyright (c) 2014 Russell Hill. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_webView.layer.cornerRadius = 10.0;
	_webView.layer.masksToBounds = YES;

	_webView.scrollView.scrollEnabled = NO;
	_webView.scrollView.bounces = NO;
	_webView.scalesPageToFit = YES;
	_webView.delegate = self;
	_webView.contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)scanButtonPressed:(id)sender {
	ScanController *scanController = [self.storyboard instantiateViewControllerWithIdentifier:@"scanController"];
	scanController.delegate = self;
	
	[self.navigationController pushViewController:scanController animated:YES];
}

- (void)itemScanned:(NSString*)data {
	[self.navigationController popViewControllerAnimated:YES];
	
	_scanLabel.hidden = TRUE;
	_webView.hidden = FALSE;
	
	// ****** load the game URL here with the passed data
	[self loadWebPage:@"http://google.com"];
}

- (void)loadWebPage:(NSString*)URLString {
	NSURL *url = [NSURL URLWithString:URLString];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	_activityIndicator.hidden = FALSE;
	[_activityIndicator startAnimating];
	
	[_webView loadRequest:requestObj];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[_activityIndicator stopAnimating];
	_activityIndicator.hidden = TRUE;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
