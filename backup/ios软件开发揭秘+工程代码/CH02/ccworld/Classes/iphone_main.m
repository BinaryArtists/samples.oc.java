#import "iphone_main.h"

//#ifdef __OBJC__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#endif

void iphone_main(int argc, char *argv[]);

static int gArgc;
static char** gArgv;


int main(int argc, char** argv) {
	gArgc = argc;
	gArgv = argv;
	
	NSAutoreleasePool *autoreleasePool = [[ NSAutoreleasePool alloc ] init];
	
    iphone_main(gArgc, gArgv);
   // int returnCode = UIApplicationMain(argc, argv, @"iPhoneMain", @"iPhoneMain");
   // int returnCode = UIApplicationMain(argc, argv, nil, nil);
	   
    [autoreleasePool release];
	//[autoreleasePool drain];
	
    return 0;
	 	
}




