//
//  main.m
//  Strings
//
//  Created by Henry Yu on 09-01-29.
//  Copyright 2009 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

void findSubString(){
	NSString *filename = @"";
	NSString *escapedPath = @"/Users/henryyu/Desktop/ClearWorks/config.ini";
	
	//在escapedPath中查找filename
	//NSRange iStart = [escapedPath rangeOfString :filename];
	NSRange iStart = [escapedPath rangeOfString: filename options:NSCaseInsensitiveSearch];
	if (iStart.length > 0){
		//获取从escapedPath开始位置到iStart.location-1长度的子字符串
		NSString *subStr = [escapedPath  substringToIndex:iStart.location-1]; 
		NSLog(@"subStr:%@",subStr);
		
	    //获取从escapedPath从iStart.location+1开始到末尾的子字符串
	    NSString *extension  = [escapedPath  substringFromIndex:iStart.location+1]; 
	    NSLog(@"extension:%@",extension);    
	
		NSString *url =	@"http://www.sevenuc.com";	
		NSRange range = NSMakeRange(0,7);
		NSString* prefix = [url substringWithRange:range];
		//获取url从0开始共7个字符的子字符串 
		if ( [prefix isEqualToString:@"http://"] )
			NSLog(@"http prefix found");
		}
}

void formatString(){
	int documentId = 100;
	NSString *documentFilename = @"test.doc";
	NSString *requestString = [NSString stringWithFormat:
							   @"<fileId>%d</fileId>\n"
							   "<strAttachmentName>%@</strAttachmentName>\n"
							   "</UploadNewDocumentAttachment>\n",
							   documentId, documentFilename];
	NSLog(@"requestString:%@",requestString);
	
}


void splitString(){
	NSString *animals = @"dog#cat#pig";
	//将#分隔的字符串转换成数组
	NSArray *array = [animals componentsSeparatedByString:@"#"];
	NSLog(@"animals:%@",array);
	
	//获取程序运行时目录
	NSString *escapedPath = [[NSBundle mainBundle] pathForResource:@"info" ofType:@"plist"];
	NSArray *strings = [escapedPath componentsSeparatedByString: @"/"];
	NSString *tmpFilename  = [strings objectAtIndex:[strings count]-1];
	NSRange iStart = [escapedPath rangeOfString : tmpFilename];
	NSString *runtimeDirectory = [escapedPath substringToIndex:iStart.location-1];
	NSLog(@"runtimeDirectory:%@",runtimeDirectory);
	
	//按行读取文件	
	NSString *tmp;
	NSArray *lines = [[NSString stringWithContentsOfFile:@"tests.txt" encoding:nil error:nil] 
					  componentsSeparatedByString:@"\n"];	
	NSEnumerator *nse = [lines objectEnumerator];	
	while(tmp = [nse nextObject]) {
		NSLog(@"tmp:%@", tmp);
	}
	
}


void cStringConvertTest(){
	//NSString 转换为char *
	NSString *blankText = @"sevensoft is a mobile software outsourcing company";
	char *ptr = [blankText cStringUsingEncoding:NSASCIIStringEncoding];
	
	printf("ptr:%s\n", ptr);
	
	//char * 转换为 NSString
	char encode_buf[1024];
	NSString *encrypted = [[NSString alloc] initWithCString:(const char*)encode_buf encoding:NSASCIIStringEncoding];
	NSLog(@"encrypted:%@", encrypted);
}


void stringCompareTest(){
	NSString *string = @""; 
	//判断字符串是否为空:
	//错误写法1
//	if(string == nil){		
//	}
	
	//错误写法2
//	if (string == [NSNull null] || string.length == 0 ){
//	}
	
	// 正确写法
	if([string length] >0){
		NSLog(@"string length >0");
	}
	
	if([string isEqualToString:@"Some String"]){
		NSLog(@"Equal to 'Some String'");
	}
	
}


int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
    findSubString();
	formatString();
	splitString();
	cStringConvertTest();
	stringCompareTest();
	
    [pool release];
    return 0;
}
