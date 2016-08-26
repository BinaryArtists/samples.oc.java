//
//  WebService.m
//
//  Created by __AUTHOR__ on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebService.h"
#import "SimpleXMLParser.h"
#import "NSData+Base64.h"
#import "Constants.h"
#import "AsyncNet.h"

@implementation WebDocWebService

static WebDocWebService *oWebService = nil;
@synthesize serviceURL, actionURL;
@synthesize  recordHead, webData, xmlParser;
@synthesize totalFileSize, progressView, progressAlert;
@synthesize currentFileName;
static	CGFloat amt = 0.0;

- init {
    if ((self = [super init])) {
		totalFileSize = 0;
		page = 0;
		team = 0;
		category = @"";
		thisParser = nil;
		progressAlert = nil;
    }
    return self;
}


- (void)setDelegate:(id)val{
    delegate = val;
}

- (id)delegate{
    return delegate;
}

// Singleton Method
//----------------------------------------------------------
+ (WebDocWebService *)instance {	 
	if(oWebService == nil){		
		oWebService = [[super alloc] init];		
	}	
	return oWebService;	
}

- (id)retain {	
	return self;	
}

- (unsigned)retainCount {	
	return NSUIntegerMax;	
}

- (void)release {	
	//do nothing	
}

- (id)autorelease {	
	return self;	
}

#pragma mark -
#pragma mark Web Service API 
//----------------------------------------------------------
-(void)wsInit{
	recordHead = @"InitResult";		
    NSString *body =
	@"<Init xmlns=\"http://tempuri.org/\">\n"
	"</Init>\n";	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
    //NSString *action = @"http://tempuri.org/Init";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/Init",actionURL];
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
}

-(void)wsInit_OpenSSL{
	
	recordHead = @"Init_OpenSLLResult";		
    NSString *body =
	@"<Init_OpenSLL xmlns=\"http://tempuri.org/\">\n"
	"</Init_OpenSLL>\n";	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
    //NSString *action = @"http://tempuri.org/Init_OpenSLL";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/Init_OpenSLL",actionURL];
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
}


-(void)wsListDomains:(NSString *)hashCode{
	recordHead = @"Domain";	
	NSString *body = [NSString stringWithFormat:
	@"<ListDomains xmlns=\"http://tempuri.org/\">\n"
	"<strHashCode>%@</strHashCode>\n"
    "</ListDomains>\n", hashCode];	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
    //NSString *action = @"http://tempuri.org/ListDomains";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListDomains",actionURL];
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
}

-(void)wsUserLogin:(NSString *)hashCode userName:(NSString *)name  
		  passWord:(NSString *)pass domainName:(NSString *)domain{
	recordHead = @"LoginUserResult";	
	NSString *body = [NSString stringWithFormat:	
	@"<LoginUser xmlns=\"http://tempuri.org/\">\n"
	"<strHashCode>%@</strHashCode>\n"
	"<strUsernameEncripted>%@</strUsernameEncripted>\n"
	"<strEncriptedPassword>%@</strEncriptedPassword>\n"
	"<strDomainNameEncripted>%@</strDomainNameEncripted>\n"
	"</LoginUser>\n",hashCode,name,pass,domain];
	
	NSLog(@"wsUserLogin:%@",body);
	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
    //NSString *action = @"http://tempuri.org/LoginUser";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/LoginUser",actionURL];
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
}

-(void)wsListMyTeams:(NSString *)hashCode
{
	recordHead = @"Team";	
    NSString *body = [NSString stringWithFormat:	
					  @"<ListMyTeams xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"					 
					  "</ListMyTeams>\n",hashCode];
	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
    //NSString *action = @"http://tempuri.org/ListMyTeams";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListMyTeams",actionURL];
	NSLog(@"wsListMyTeams:%@",body);
    [self doWebService: body sSoapXML:url sSOAPAction:action];
	
}

-(void)wsListMyDocumentTeams:(NSString *)hashCode StateTo:(NSString *)state Group:(NSString *)group
{
		
    recordHead = @"Team";	
    NSString *body = [NSString stringWithFormat:	
				  @"<ListWorkflowTeamTo xmlns=\"http://tempuri.org/\">\n"
				  "<strHashCode>%@</strHashCode>\n"
				  "<intWorkflowStateToID>%@</intWorkflowStateToID>\n"
				  "<strFilterGroupName>%@</strFilterGroupName>\n"
				  "</ListWorkflowTeamTo>\n",hashCode,state,group];

    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
    //NSString *action = @"http://tempuri.org/ListWorkflowTeamTo";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListWorkflowTeamTo",actionURL];
	NSLog(@"wsListMyDocumentTeams:%@",body);
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
	
}

-(void)wsListWorkflowUsers:(NSString *)hashCode StateTo:(NSString *)state Team:(NSString *)teamNo
{
	//team id is the ListWorkflowTeamTo value, otherwise is 0
	recordHead = @"User";	
    NSString *body = [NSString stringWithFormat:	
					  @"<ListWorkflowUsersTo xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<intWorkflowStateToID>%@</intWorkflowStateToID>\n"
					  "<intIDTeam>%@</intIDTeam>\n"
					  "</ListWorkflowUsersTo>\n",hashCode,state,teamNo];
	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
    //NSString *action = @"http://tempuri.org/ListWorkflowUsersTo";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListWorkflowUsersTo",actionURL];
	NSLog(@"wsListWorkflowUsers:%@",body);
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
}

-(void)wsListMyDocuments:(NSString *)hashCode 
             PageRowSize:(NSInteger)rowsize  CurrentPage:(NSInteger)pageNo{
	page = pageNo;
	category = MyDocument;	
	recordHead = @"GDDocument";	
	NSString *body = [NSString stringWithFormat:	
	@"<ListMyDocuments xmlns=\"http://tempuri.org/\">\n"
	"<strHashCode>%@</strHashCode>\n"
	"<intPageRowSize>%d</intPageRowSize>\n"
	"<intCurrentPage>%d</intCurrentPage>\n"
    "</ListMyDocuments>\n",hashCode,rowsize,pageNo];
	
	NSLog(@"wsListMyDocuments:%@",body);
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
    //NSString *action = @"http://tempuri.org/ListMyDocuments";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListMyDocuments",actionURL];
    [self doWebService: body sSoapXML:url sSOAPAction:action];
	
}

-(void)wsListMyDocumentsByDepartment:(NSString *)hashCode 
		PageRowSize:(NSInteger)rowsize  CurrentPage:(NSInteger)pageNo 
							  TeamID:(NSInteger)teamNo{
	page = pageNo;
	team = teamNo;
	category = MyTeamDocument;
	recordHead = @"GDDocument";	
	NSString *body = [NSString stringWithFormat:	
					  @"<ListMyTeamDocuments xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<intPageRowSize>%d</intPageRowSize>\n"
					  "<intCurrentPage>%d</intCurrentPage>\n"
					  "<intIDTeam>%d</intIDTeam>\n"
					  "</ListMyTeamDocuments>\n",hashCode,rowsize,pageNo,teamNo];
	
	NSLog(@"wsListMyDocumentsByDepartment:%@",body);
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
    //NSString *action = @"http://tempuri.org/ListMyTeamDocuments";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListMyTeamDocuments",actionURL];
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
	
}

-(void)wsGetDocFile:(NSString *)hashCode DocumentID:(NSString *)document
		   FileName:(NSString *)filename 
		  Extension:(NSString *)extension IsAnexo:(BOOL)isAnexo{
   	recordHead = @"GetDocFileResult";	
	NSString *body = [NSString stringWithFormat:	
					  @"<GetDocFile xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<MyDocFile>\n"
					  "<IDFILE>%@</IDFILE>\n"
					  "<FileName>%@</FileName>\n"
					  "<Extension>%@</Extension>\n"
					  "<IsAttachment>%@</IsAttachment>\n"
					  "</MyDocFile>\n"
					  "</GetDocFile>\n",
					  hashCode,document,filename,extension,isAnexo?@"true":@"false"];
	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSDownload.asmx";
    //NSString *action = @"http://tempuri.org/GetDocFile";
	NSString *url = [NSString stringWithFormat:@"%@/WSDownload.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/GetDocFile",actionURL];
	
	NSLog(@"wsGetDocFile:%@",body);
				
    [self doWebService: body sSoapXML:url sSOAPAction:action];
	
	//return: <GetDocumentFileResult>base64Binary</GetDocumentFileResult>
	[self createProgressionAlertWithMessage:@"download Attachment ..." withActivity:NO];
	
}

-(void)wsGetDocumentFile:(NSString *)hashCode 
			  DocumentID:(NSString *)document{	
	recordHead = @"GetDocumentFileResult";	
	NSString *body = [NSString stringWithFormat:	
					  @"<GetDocumentFile xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<strDocumentIDEncrypted>%@</strDocumentIDEncrypted>\n"
					  "</GetDocumentFile>\n",hashCode,document];
	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSDownload.asmx";
    //NSString *action = @"http://tempuri.org/GetDocumentFile";
	NSString *url = [NSString stringWithFormat:@"%@/WSDownload.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/GetDocumentFile",actionURL];
    [self doWebService: body sSoapXML:url sSOAPAction:action];
	
	//reurn:<GetDocumentFileResult>base64Binary</GetDocumentFileResult>
}

-(void)wsGetAttachmentFile:(NSString *)hashCode 
			  AttachmentID:(NSString *)attachment{
	recordHead = @"GetAttachmentFileResult";	
	NSString *body = [NSString stringWithFormat:	
					  @"<GetAttachmentFile xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<strAttachmentIDEncrypted>%d</strAttachmentIDEncrypted>\n"
					  "</GetAttachmentFile>\n",hashCode,attachment];
	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSDownload.asmx";
    //NSString *action = @"http://tempuri.org/GetAttachmentFile";
	NSString *url = [NSString stringWithFormat:@"%@/WSDownload.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/GetAttachmentFile",actionURL];
    [self doWebService: body sSoapXML:url sSOAPAction:action];
	
	//return:<GetAttachmentFileResult>base64Binary</GetAttachmentFileResult>
	[self createProgressionAlertWithMessage:@"download Attachment ..." withActivity:NO];
	
}

-(void)wsUpLoadFile:(NSString *)data{
	recordHead = @"UploadFileResult";	
	
   // NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSUpload.asmx";
   // NSString *action = @"http://tempuri.org/UploadFile";
	NSString *url = [NSString stringWithFormat:@"%@/WSUpload.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/UploadFile",actionURL];
	NSLog(@"wsUpLoadFile:%@",data);
    [self doWebService: data sSoapXML:url sSOAPAction:action];
	[self createProgressionAlertWithMessage:@"Upload Document ..." withActivity:NO];	
}

- (void) handleTimer2: (id) atimer
{
	if ([delegate respondsToSelector:@selector(didOperationError:)]){
		//An error occurred
		NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
		[errorDetail setValue:@"Time out,failed to upload file" forKey:NSLocalizedDescriptionKey];
		NSError *error = [NSError errorWithDomain:@"WebDoc Mobile" code:100 userInfo:errorDetail];		
        [delegate performSelector:@selector(didOperationError:) withObject: error];
		[error release];
	}	  
	[atimer invalidate];
	atimer = nil;
	
}

-(void)wsUpLoadAttachment:(NSString *)data{
	recordHead = @"UploadNewDocumentAttachmentResult";		
	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSUpload.asmx";
    //NSString *action = @"http://tempuri.org/UploadNewDocumentAttachment";
	NSString *url = [NSString stringWithFormat:@"%@/WSUpload.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/UploadNewDocumentAttachment",actionURL];
	
	NSLog(@"wsUpLoadAttachment:%@",data);
	
	/*
	timer2 = [NSTimer scheduledTimerWithTimeInterval: UPLOAD_TIMEOUT
											 target: self
										   selector: @selector(handleTimer2:)
										   userInfo: nil
											repeats: NO];
	 */
	
    [self doWebService: data sSoapXML:url sSOAPAction:action];
	[self createProgressionAlertWithMessage:@"Upload Document ..." withActivity:NO];
}

-(void)wsListFileHistory:(NSString *)hashCode 
			  DocumentID:(NSString *)document{
	recordHead = @"MovimentHistory";	
	NSString *body = [NSString stringWithFormat:
					  @"<GetDocumentHistoryResumed xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<strDocumentIDEncrypted>%@</strDocumentIDEncrypted>\n"
					  "</GetDocumentHistoryResumed>\n", hashCode,document];	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
    //NSString *action = @"http://tempuri.org/GetDocumentHistoryResumed";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/GetDocumentHistoryResumed",actionURL];
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
		
}

-(void)wsDoWorkFlow:(NSString *)hashCode DocumentID:(NSString *)document StateTo:(NSString *)state 
			 TeamTo:(NSString *)teamNo UserTo:(NSString *)user Comment:(NSString *)comment
{
	//the IDTeamTo can be null if a IDUserTo is geater than 0 or vice versa.
		
	recordHead = @"FowardWkfResult";	
	NSString *body = [NSString stringWithFormat:
					  @"<FowardWkf xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<strDocumentIDEncrypted>%@</strDocumentIDEncrypted>\n"
					  "<intIDWorkflowStateTo>%@</intIDWorkflowStateTo>\n"
					  "<intIDTeamTo>%@</intIDTeamTo>\n"
					  "<intIDUserTo>%@</intIDUserTo>\n"
					  "<strRemarks>%@</strRemarks>\n"
					  "</FowardWkf>\n", hashCode,document,state,teamNo,user,comment];	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSCreate.asmx";
    //NSString *action = @"http://tempuri.org/FowardWkf";
	NSString *url = [NSString stringWithFormat:@"%@/WSCreate.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/FowardWkf",actionURL];	
	NSLog(@"wsDoWorkFlow:%@",body);
    [self doWebService: body sSoapXML:url sSOAPAction:action];
}

-(void)wsListIndicators:(NSString *)hashCode
{
	recordHead = @"Indicator";	
	NSString *body = [NSString stringWithFormat:
					  @"<GetIndicators xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"					 
					  "</GetIndicators>\n", hashCode];	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSStats.asmx";
    //NSString *action = @"http://tempuri.org/GetIndicators";
	NSString *url = [NSString stringWithFormat:@"%@/WSStats.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/GetIndicators",actionURL];
	
	NSLog(@"wsListIndicators:%@",body);
	
    [self doWebService: body sSoapXML:url sSOAPAction:action];
}

-(void)wsGetIndicatorDetails:(NSString *)hashCode Indicator:(NSString *)indicatorId {
		
	recordHead = @"GetIndicatorDetailsResult";	
	NSString *body = [NSString stringWithFormat:
					  @"<GetIndicatorDetails xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"	
					  "<intIndicatorID>%@</intIndicatorID>\n"
					  "</GetIndicatorDetails>\n", hashCode,indicatorId];	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSStats.asmx";
    //NSString *action = @"http://tempuri.org/GetIndicatorDetails";
	NSString *url = [NSString stringWithFormat:@"%@/WSStats.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/GetIndicatorDetails",actionURL];
	NSLog(@"wsListIndicators:%@",body);
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
}

-(void)wsGetIndicatorDetailsImage:(NSString *)hashCode Indicator:(NSString *)indicatorId {

	recordHead = @"GetIndicatorDetailsImageResult";	
	NSString *body = [NSString stringWithFormat:
					  @"<GetIndicatorDetailsImage xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"	
					  "<intIndicatorID>%@</intIndicatorID>\n"
					  "</GetIndicatorDetailsImage>\n", hashCode,indicatorId];	
	//NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSStats.asmx";
	//NSString *action = @"http://tempuri.org/GetIndicatorDetailsImage";
	NSString *url = [NSString stringWithFormat:@"%@/WSStats.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/GetIndicatorDetailsImage",actionURL];
	NSLog(@"wsListIndicators:%@",body);
	[self doWebService: body sSoapXML:url sSOAPAction:action];

}


-(void)wsTotalMyDocuments:(NSString *)hashCode{
	recordHead = @"TotalMyDocumentsResult";			
	NSString *body = [NSString stringWithFormat:
					  @"<TotalMyDocuments xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "</TotalMyDocuments>\n", hashCode];	
	//NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
	//NSString *action = @"http://tempuri.org/TotalMyDocuments";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/TotalMyDocuments",actionURL];
	[self doWebService: body sSoapXML:url sSOAPAction:action];
}

-(void)wsTotalMyTeamDocuments:(NSString *)hashCode TeamId:(NSString *)teamNo{
	recordHead = @"TotalMyTeamDocumentsResult";			
	NSString *body = [NSString stringWithFormat:
					  @"<TotalMyTeamDocuments xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<intIDTeam>%@</intIDTeam>\n"
					  "</TotalMyTeamDocuments>\n", hashCode, teamNo];	
	//NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
	//NSString *action = @"http://tempuri.org/TotalMyTeamDocuments";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/TotalMyTeamDocuments",actionURL];
	[self doWebService: body sSoapXML:url sSOAPAction:action];
}


-(void)wsListWorkflowStates:(NSString *)hashCode{
	recordHead = @"WorkFlowState";			
	NSString *body = [NSString stringWithFormat:
					  @"<ListWorkflowStates xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "</ListWorkflowStates>\n", hashCode];	
	//NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
	//NSString *action = @"http://tempuri.org/ListWorkflowStates";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListWorkflowStates",actionURL];
	NSLog(@"wsListWorkflowStates:%@",body);
	[self doWebService: body sSoapXML:url sSOAPAction:action];
}

-(void)wsListWorkflowStatesTo:(NSString *)hashCode DocumentID:(NSString *)document
{
	 recordHead = @"WorkFlowState";	
	 NSString *body = [NSString stringWithFormat:
	 @"<ListWorkflowStateTo xmlns=\"http://tempuri.org/\">\n"
	 "<strHashCode>%@</strHashCode>\n"
	 "<strDocumentIDEncrypted>%@</strDocumentIDEncrypted>\n"
	 "</ListWorkflowStateTo>\n", hashCode, document];	
	// NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
	// NSString *action = @"http://tempuri.org/ListWorkflowStateTo";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListWorkflowStateTo",actionURL];
	NSLog(@"wsListWorkflowStatesTo:%@",body);
	 [self doWebService: body sSoapXML:url sSOAPAction:action];
	
}

-(void)wsListDirections:(NSString *)hashCode{
		
	recordHead = @"GDBook";	
	NSString *body = [NSString stringWithFormat:
					  @"<ListBooks xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "</ListBooks>\n", hashCode];	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
    //NSString *action = @"http://tempuri.org/ListBooks";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListBooks",actionURL];
	NSLog(@"wsListDirections:%@",body);
    [self doWebService: body sSoapXML:url sSOAPAction:action];
}	

-(void)wsGetDocumentDataResumed:(NSString *)hashCode DocumentID:(NSString *)document
{
	recordHead = @"GetDocumentDataResumedResult";	
	NSString *body = [NSString stringWithFormat:
					  @"<GetDocumentDataResumed xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<strDocumentIDEncrypted>%@</strDocumentIDEncrypted>\n"
					  "</GetDocumentDataResumed>\n", hashCode, document];	
   // NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
   // NSString *action = @"http://tempuri.org/GetDocumentDataResumed";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/GetDocumentDataResumed",actionURL];
    [self doWebService: body sSoapXML:url sSOAPAction:action];
	
}

-(void)wsListDocumentAttachments:(NSString *)hashCode DocumentID:(NSString *)document
{	
	recordHead = @"DocFile";	
	NSString *body = [NSString stringWithFormat:
					  @"<ListDocumentFiles xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<strDocumentIDEncrypted>%@</strDocumentIDEncrypted>\n"
					  "</ListDocumentFiles>\n", hashCode, document];	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
    //NSString *action = @"http://tempuri.org/ListDocumentFiles";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListDocumentFiles",actionURL];
	NSLog(@"wsListDocumentAttachments:%@",body);
    [self doWebService: body sSoapXML:url sSOAPAction:action];
	
}

-(void)wsListDocumentTypes:(NSString *)hashCode 
		DocumentID:(NSString *)document{
	recordHead = @"GDDocumentType";		
	NSString *body = [NSString stringWithFormat:
					  @"<ListDocumentTypes xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<intBookID>%@</intBookID>\n"
					  "</ListDocumentTypes>\n", hashCode,document];	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
    //NSString *action = @"http://tempuri.org/ListDocumentTypes";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListDocumentTypes",actionURL];
	NSLog(@"wsListDocumentTypes:%@",body);
	
    [self doWebService: body sSoapXML:url sSOAPAction:action];
}

-(void)wsAdvancedSearch:(NSString *)code 
			PageRowSize:(NSInteger)rowsize  
			CurrentPage:(NSInteger)pageNo 
           DocumentCode:(NSString *)docment
			 WorkflowState:(NSString *)state 			 
              DocumentType:(NSString *)type
              Direction:(NSString *)direction
              Entity:(NSString *)entity{
		
	recordHead = @"GDDocument";		
	NSString *body = [NSString stringWithFormat:
					  @"<ListDocuments xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<intPageRowSize>%d</intPageRowSize>\n"
					  "<intCurrentPage>%d</intCurrentPage>\n"
					  "<strDocumentCode>%@</strDocumentCode>\n"
					  "<strWorkflowStateLabel>%@</strWorkflowStateLabel>\n"
					  "<intDocumentType>%@</intDocumentType>\n"
					  "<intGDBook>%@</intGDBook>\n"
					  "<strEntity>%@</strEntity>\n"					  
					  "</ListDocuments>\n", code,rowsize,pageNo,docment,state,type,direction,entity];	
    //NSString *url = @"http://demos.ambisig.com/WebDoc_WSServices/WSGetInfo.asmx";
    //NSString *action = @"http://tempuri.org/ListDocuments";
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListDocuments",actionURL];
	
	NSLog(@"wsAdvancedSearch:%@",body);
	
    [self doWebService: body sSoapXML:url sSOAPAction:action];		
	
}

#pragma mark -
#pragma mark AsyncNet API

- (void)asyncRequestSucceeded:(NSData *)data
						  userInfo:(NSDictionary *)userInfo
{
	if(data == nil) return;
	
	NSString *tmpdata = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"[***] SERVER DATA:%@",tmpdata);	
//	[tmpdata release];
	
    NSString *iRecordHead = [userInfo objectForKey:@"recordHead"];
	int isDownload = [[userInfo objectForKey:@"isDownload"] intValue];
	
	//thisParser = [[SimpleXMLParser alloc] initWithData:data];	
	if(thisParser == nil)
		thisParser = [[SimpleXMLParser alloc] init];
	[thisParser initData:(NSMutableData*)data];	
	[thisParser parse:iRecordHead];	
	BOOL isFault = [thisParser isContentFault];
	NSLog(@"[***] SERVER isFault:%d", isFault);	
	
	if(isDownload){
		if(timer != nil){
			[timer invalidate];
			timer = nil;
		}
		if(progressAlert != nil){
		    [progressAlert dismissWithClickedButtonIndex:0 animated:YES]; 
		    [progressAlert release];
		     progressAlert = nil;
		}
		//write data to file.
		if(!isFault && [iRecordHead isEqualToString:@"GetAttachmentFileResult"])
		  [self writeToLocalFile];
	}
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]
									 initWithCapacity:4];		
	[dict setObject:[userInfo objectForKey:@"page"] forKey:@"page"];
	[dict setObject:[userInfo objectForKey:@"team"] forKey:@"team"];
	[dict setObject:iRecordHead forKey:@"recordHead"];
	[dict setObject:[thisParser getRecordLists] forKey:@"Data"];
	
	if(isFault){
		NSString *faultPrefix = @"<faultstring>";
		NSRange range1 = [tmpdata rangeOfString:faultPrefix options:NSCaseInsensitiveSearch];		
		NSString *errorMessage;
		if (range1.length > 0){
			NSString *tempString = [tmpdata substringFromIndex:range1.location+[faultPrefix length]];
			NSRange range2 = [tempString rangeOfString:@"</faultstring>" options:NSCaseInsensitiveSearch];
			if(range2.length > 0)
			  errorMessage = [tempString substringToIndex:range2.location]; 
		}else{
			errorMessage = @"Server response a fault message";
		}			
		[tmpdata release];				
		NSDictionary *description = [NSDictionary dictionaryWithObject: errorMessage 
								 forKey:NSLocalizedDescriptionKey];
		NSError *error = [[[NSError alloc] 
			initWithDomain:@"com.ambisig.webdoc" code:7 userInfo:description] autorelease];
		[self asyncRequestFailed:error userInfo:userInfo];		
		return;
	}	
	[tmpdata release];
	if ([[self delegate] respondsToSelector:@selector(didOperationCompleted:)]){
		[[self delegate] didOperationCompleted:dict];	
	}
	
}

- (void)asyncRequestFailed:(NSError *)error
					   userInfo:(NSDictionary *)userInfo
{
    //NSString *iRecordHead = [userInfo objectForKey:@"recordHead"];
	//int isDownload = [[userInfo objectForKey:@"isDownload"] intValue];
	if(timer != nil){
		[timer invalidate];
		timer = nil;
	}
    if(progressAlert != nil){
		[progressAlert dismissWithClickedButtonIndex:0 animated:YES]; 
		progressAlert = nil;
	}
	
	if ([delegate respondsToSelector:@selector(didOperationError:)])
        [delegate performSelector:@selector(didOperationError:) withObject: error];
	else{
		//do something.
	}
}


#pragma mark -
#pragma mark Web Service Delegate 
//---------------------------------------------------------------------------------------

-(void)doWebService:(NSString *)sSoapBody sSoapXML:(NSString *)xml 
		sSOAPAction:(NSString *)action{
	
	NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "%@"
							 "</soap:Body>\n"
							 "</soap:Envelope>\n",sSoapBody];
	//encapsolute the soap package message.
	NSURL *url = [NSURL URLWithString:xml];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: action forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];

/*
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if( theConnection )
	{
		webData = [[NSMutableData data] retain];
	}
	else
	{
		UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle: @"WebDoc Mobile"
								   message: @"Cannot establish network connection."
								   delegate:nil
								   cancelButtonTitle:@"OK"
								   otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}	
*/
	//-------------------------------------------------------------------------------------
	NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]
									 initWithCapacity:5];
	
	[userInfo setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
	[userInfo setObject:[NSNumber numberWithInteger:team] forKey:@"team"];
	[userInfo setObject:category forKey:@"category"];
	[userInfo setObject:recordHead forKey:@"recordHead"];
	
	int isDownload = ([recordHead isEqualToString:@"GetAttachmentFileResult"]
	   ||[recordHead isEqualToString:@"UploadNewDocumentAttachmentResult"])? 1:0;
	//int isDownload = (progressAlert != nil) ? 1:0;
	[userInfo setObject:[NSNumber numberWithInt:isDownload] forKey:@"isDownload"];	
		
	[[AsyncNet instance]
	 addRequest:theRequest
	 successTarget:self
	 successAction:@selector(asyncRequestSucceeded:userInfo:)
	 failureTarget:self
	 failureAction:@selector(asyncRequestFailed:userInfo:)
	 userInfo:userInfo];
	
	 [userInfo release];	
	
}


-(void)connection:(NSURLConnection *)connection 
      didReceiveResponse:(NSURLResponse *)response{
	[webData setLength: 0];
	 	
	//server return the total message size.
	totalFileSize  = [NSNumber numberWithLongLong:[response expectedContentLength]]; 
	[totalFileSize retain];
	 
}

-(void)connection:(NSURLConnection *)connection 
   didReceiveData:(NSData *)data{
	[webData appendData:data];
	// ....
	if(progressAlert != nil){
	   NSNumber *resourceLength = [NSNumber numberWithUnsignedInteger:[webData length]]; 
	   long loc_long = [resourceLength longValue];
	   if (loc_long == 0)
			return;			   	
	   NSNumber *progress = [NSNumber numberWithFloat:([resourceLength floatValue]/[totalFileSize floatValue])]; 
	   // progress += 0.01;
		//if (progress <= 1.0)
		//{
		//	[progressView setProgress: progress ];
		//	[ progressView updateIfNecessary ];
		//}
		progressView.progress = [progress floatValue]; 

	   const unsigned int bytes = 1024*1024; 
	   UILabel *label = (UILabel *)[progressAlert viewWithTag:1]; 
	   NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init]; 
	   [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; 
	   [formatter setPositiveFormat:@"##0.00"]; 
	   NSNumber *partial = [NSNumber numberWithFloat:([resourceLength floatValue]/bytes)]; 
	   NSNumber *total = [NSNumber numberWithFloat:([totalFileSize floatValue]/bytes)]; 
	   label.text = [NSString stringWithFormat:@"%@ MB of %@ MB",
			 [formatter stringFromNumber:partial], [formatter stringFromNumber:total]]; 
	   [formatter release];
		
	}
	
}

-(void)setCurrentFileName:(NSString *)filename{
	currentFileName = filename;
	[currentFileName retain];
}

-(void)writeToLocalFile{

	 if(currentFileName == nil ||[currentFileName length] == 0)
		 return;
	 NSString *base64Binary = nil;
	 if([self getRecordCount]){					
		NSDictionary *recordDict = [self getRecordAtIndex:0];
		base64Binary = [recordDict objectForKey:@"value"];	    
	 }else{
		 return;
	 }
	
	 //@"/private/var/root/"; //NSHomeDirectory();
	 NSString *newFilePath = [NSString stringWithFormat: @"%@/%@", DOWNLOAD_DIRECTORY,currentFileName];
	 [[NSFileManager defaultManager] createFileAtPath:newFilePath contents:nil attributes:nil];
	 NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath: newFilePath append:NO];
	 [outputStream open];
	 NSData *data = [NSData dataFromBase64String:base64Binary];
	 [base64Binary release];
	 NSString *strBuf = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	 [data release];
	 const char* cString = (const char*)strBuf;			
	 UInt16 stringOffset = 0;
	 uint8_t outputBuf [1];
	 while ( ((outputBuf[0] = cString[stringOffset]) != 0) &&
	      [outputStream hasSpaceAvailable] ) {
	           [outputStream write: (const uint8_t *) outputBuf maxLength: 1];
	           stringOffset++;
	 }
	
	 [outputStream close];
	 [strBuf release];
	 
	 NSString *msg = [NSString stringWithFormat:@"File download to %@ ok.",newFilePath];
	 [self messageBox:msg Error:nil];
	
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
/*	 
	NSString *tmpdata = [[NSString alloc] initWithData:webData encoding:NSASCIIStringEncoding];
	NSLog(@"SERVER DATA:%@",tmpdata);	
	[tmpdata release];
	
	thisParser = [[SimpleXMLParser alloc] initWithData:webData];	
	[thisParser parse:recordHead];	
	
	if(progressAlert != nil){
		if(timer != nil){
		   [timer invalidate];
			timer = nil;
		}
		[progressAlert dismissWithClickedButtonIndex:0 animated:YES]; 
		[progressAlert release];
		 progressAlert = nil;
		//write data to file.
		[self writeToLocalFile];
	}
	
	if ([[self delegate] respondsToSelector:@selector(didOperationCompleted:)]){
		[[self delegate] didOperationCompleted:recordHead];	
	}
	*/
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	if(progressAlert != nil){
	   [timer invalidate];
	   [progressAlert dismissWithClickedButtonIndex:0 animated:YES]; 
	}
	if ([delegate respondsToSelector:@selector(didOperationError:)])
        [delegate performSelector:@selector(didOperationError:) withObject: error];
	else{
		//do something.
	}
}

- (NSMutableArray*) getRecordLists{
	if(thisParser)
		return [thisParser getRecordLists];
	else
		return nil;	
}

- (NSInteger) getRecordCount{
	if(thisParser)
	   return [thisParser getRecordCount];
	else
	  return 0;	
}

- (NSDictionary*) getRecordAtIndex:(NSInteger)idx{
	if(thisParser)
		return [thisParser getRecordAtIndex:idx];	
	else
		return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc{
	if(timer != nil){
		[timer invalidate];
	}
	if(progressAlert != nil)
	  [progressAlert release];
	if(thisParser != nil)
		[thisParser release];	
	[super dealloc];	
}


- (void) handleTimer: (id) atimer
 {
	  amt += 1;
	 if(progressView != nil)
	    [progressView setProgress: (amt / DOWNLOAD_TIMEOUT)];
	 if (amt > DOWNLOAD_TIMEOUT) {
		 UILabel *label = (UILabel *)[progressAlert viewWithTag:1]; 
		 label.text = @"Sorry, Time Out..."; 		  
		 [atimer invalidate];
		 atimer = nil;
		 [progressAlert dismissWithClickedButtonIndex:0 animated:TRUE];		 
		 [progressAlert release];
		 progressAlert = nil;
	 }
 }

- (void) createProgressionAlertWithMessage:(NSString *)message 
							  withActivity:(BOOL)activity{
		
	if(progressAlert != nil){
		[progressAlert release];
		progressAlert = nil;
	}
	// This timer takes the place of a real task
	amt = 0.0;
	timer = [NSTimer scheduledTimerWithTimeInterval: 0.5
												target: self
											  selector: @selector(handleTimer:)
											  userInfo: nil
											   repeats: YES];
	
	if(!progressAlert)
	{
	    progressAlert = [[UIAlertView alloc] initWithTitle: message
															message: @"Please wait..."
														   delegate: self
												  cancelButtonTitle: nil
												  otherButtonTitles: nil];
	
	   // Create the progress bar and add it to the alert
	   if (activity) {
		   UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] 
						initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		   activityView.frame = CGRectMake(139.0f-18.0f, 80.0f, 37.0f, 37.0f);
		   [progressAlert addSubview:activityView];
		   [activityView startAnimating];
		   [activityView release];		   		
		   
	   } else {
		   progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 225.0f, 90.0f)];
		   [progressAlert addSubview:progressView];
		   [progressView setProgressViewStyle: UIProgressViewStyleBar];
		   [progressView release];
	   }
		
		// Add a label to display download/upload size.
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 90.0f, 225.0f, 40.0f)]; 
		label.backgroundColor = [UIColor clearColor]; 
		label.textColor = [UIColor whiteColor]; 
		label.font = [UIFont systemFontOfSize:12.0f]; 
		label.text = @""; 
		label.tag = 1; 
		[progressAlert addSubview:label]; 	   
	}
	
	[progressAlert show];		
	
}


- (void)messageBox:(NSString*)message Error:(NSError*)error{
	
	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle: ((error != nil) ? [error localizedDescription]:@"")
							   message: ((error != nil) ? [error localizedFailureReason]:message)
							   delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}

@end
