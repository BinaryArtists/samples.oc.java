//
//  UIDialView.m
//  RadioDial
//
//  Created by Henry, Yu on 3/11/10.
//  Copyright 2010  Sevenuc.com. All rights reserved.
//


#import "UIDialView.h"

@interface UIDialView()
-(void)spin:(NSTimer *)timer;
-(float) goodDegrees:(float)degrees;
@end

#define degreesToRadians(degrees) (M_PI * degrees / 180.0)
#define radiansToDegrees(radians) (radians * 180 / M_PI)


static CGPoint delta;
static float deltaAngle;
static float currentAngle;

@implementation UIDialView
@synthesize initialTransform,currentValue;

- (void)dealloc {
	[iv release];
    [super dealloc];
}

@synthesize delegate;

- (id)init{
    if ((self = [super init])) {
		
		self.userInteractionEnabled = YES;
		iv =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"knob.png"]];
		
		UIImage *backgroundTile = [UIImage imageNamed: @"clock.png"];
		UIColor *backgroundPattern = [[UIColor alloc] initWithPatternImage:backgroundTile];
		self.contentMode = UIViewContentModeCenter;
		[self setBackgroundColor:backgroundPattern];
		[backgroundPattern release];		
		
		iv.backgroundColor = [UIColor clearColor]; 
		iv.autoresizesSubviews= YES;		
		self.frame = CGRectMake(0, 0, iv.frame.size.width, iv.frame.size.height);
		
		[self addSubview:iv];		
		[self bringSubviewToFront:iv];
		[iv release];
		
		currentValue = 0;
		currentAngle = 0;	
		deltaAngle = 0.0;
		timer = nil;
		
		minValue = 20;
		maxValue = 120;
		
	}
    return self;
}

#pragma mark -
#pragma mark UIViewDelegate touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if(deltaAngle > 0.0){
		return;
	}
	
	timer = [NSTimer scheduledTimerWithTimeInterval:.03
					target:self selector:@selector(spin:) userInfo:nil repeats:YES];
		
	UITouch *thisTouch = [touches anyObject];
	delta = [thisTouch locationInView:self];
	
	float dx = delta.x  - iv.center.x;
	float dy = delta.y  - iv.center.y;
	deltaAngle = atan2(dy,dx); 	

	//set an initial transform so we can access these properties through the rotations
	initialTransform = iv.transform;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
	
	float dx = pt.x  - iv.center.x;
	float dy = pt.y  - iv.center.y;
	float ang = atan2(dy,dx);
		
	//do the rotation
	if (deltaAngle == 0.0) {
		deltaAngle = ang;
		initialTransform = iv.transform;		
	}else{
		//from last move to now...
		float angleDif = deltaAngle - ang;
		//NSLog(@"angleDif %f in radians and in degrees %f",ang,
		//    [self goodDegrees:radiansToDegrees(ang)]);
			
		float diffValue = [self goodDegrees:radiansToDegrees(angleDif)];		
		currentValue = maxValue - ((maxValue - minValue)/300)*diffValue;
		if(currentValue > 100){
			currentValue = 100;
			return;
		}
		NSLog(@" currentValue:%f", currentValue);
		//concatonate the transform with the angle difference
		CGAffineTransform newTrans = CGAffineTransformRotate(initialTransform, -angleDif);
		iv.transform = newTrans;
	}
	
	if (delegate != nil) {
		[delegate dialValue:self.tag Value:currentValue];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if (delegate != nil) {
		[delegate dialValue:self.tag Value:currentValue];
	}
	if(timer != nil){
		[timer invalidate];
		timer = nil;
	}	
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	if(timer != nil){
		[timer invalidate];
		timer = nil;
	}
}

-(void)spin:(NSTimer *)timer{
	//iv.transform = CGAffineTransformMakeRotation(currentAngle);	
}

-(float) goodDegrees:(float)degrees{
	float degOutput = degrees;
	while (degOutput >=360) {
		degOutput -= 360;
	}
	while (degOutput < 0) {
		degOutput += 360;
	}
	return degOutput;
}

@end
