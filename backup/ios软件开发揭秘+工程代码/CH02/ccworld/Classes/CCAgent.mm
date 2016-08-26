//
//  CCAgent.mm
//  ccworld
//
//  Created by Henry Yu on 10-11-07.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "CCAgent.h"
#include "Library.h"

id agentRef;

static void callbackTest(void){
    [agentRef callbackInner];
}

@implementation CCAgent

@synthesize delegate;

- (id)init{
	self = [super init];
	if (self != nil){
		agentRef = self;		
	}
	return self;
}

- (void)callbackInner{
	if ([self.delegate respondsToSelector:@selector(renderCompleted:)]){
		[self.delegate renderCompleted:@"operation completed in C++"];	
	}	
}

- (void)InitEngine{	
	if(!osystem)
		osystem->OSystem_Init();
	if(osystem){
	    osystem->_RenderWindow->Render = callbackTest;			
	}
}

- (void)StartEngine:(NSString*)str{
	const char* cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
	osystem->StartEngine(cstr);
}

- (NSInteger)GetChannelList{			
	int length = sizeof(char)* 1024 * 2;
	NSMutableData* data = [NSMutableData dataWithLength:length];
	char* ptr = (char*)[data mutableBytes];
	int result = osystem->GetChannelList(ptr);	
	if(result){
	    NSString *tmpdata = [[NSString alloc] 
				 initWithData:data encoding:NSASCIIStringEncoding];
		//if ([self.delegate respondsToSelector:
		//      @selector(getChannelListCompleted:)]){
		//	[self.delegate getChannelListCompleted:tmpdata];	
		//}	
		NSLog(@"%@",tmpdata);
		[tmpdata release];
		return 0;
	}else{		
	    return 1;
	}
}

- (void)dealloc{
	osystem->Exit();
	[super dealloc];
}


@end

