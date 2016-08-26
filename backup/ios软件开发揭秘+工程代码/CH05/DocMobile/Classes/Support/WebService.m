//
//  WebService.m
//
//  Created by Henry Yu on 09-09-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
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
    
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/Init",actionURL];
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
}

-(void)wsInit_OpenSSL{
	
	recordHead = @"Init_OpenSLLResult";		
	
#ifdef USING_LOCAL_DATA
	NSString *localData = @"<soap:Body><Init_OpenSLLResponse xmlns=\"http://tempuri.org/\">"
	"<Init_OpenSLLResult><HashCode>0ef44f47-0de9-4923-a5b5-b8308ba02ba5</HashCode><PublicKey>"
	"-----BEGIN PUBLIC KEY-----"
	"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCrHiTP0Yuya6CStpeXEOh5Fni/"
	"dmwS/6aGT5O1QUdXl0hTZpv4pZUOMR0LF7ciK0AcDIPT8O/hi/KJyMVEdL4kg15/"
	"q4znvUfh874IN2BLjeiPM0uum3jzeEZa2H3sE8M5QHmzTWZEUVCUvk4CVGEDXqeP"
	"HGIyGFnaMPy2/qNXyQIDAQAB"
	"-----END PUBLIC KEY-----"
	"</PublicKey><PrivateKey /></Init_OpenSLLResult></Init_OpenSLLResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body =
	@"<Init_OpenSLL xmlns=\"http://tempuri.org/\">\n"
	"</Init_OpenSLL>\n";	
    
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/Init_OpenSLL",actionURL];
	
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif	
	
}

- (void)wsListDomains:(NSString *)hashCode{
	recordHead = @"Domain";	
	
#ifdef USING_LOCAL_DATA
	
	NSString *localData = 
	@"<soap:Body><ListDomainsResponse xmlns=\"http://tempuri.org/\">"
	"<ListDomainsResult><Domain><IDDomain>2</IDDomain>"
	"<DomainName>AmbiSIG</DomainName><Domain>AmbiSIG</Domain></Domain>"
	"<Domain><IDDomain>1</IDDomain><DomainName>Interno</DomainName>"
	"<Domain>INTERNAL</Domain></Domain>"
	"</ListDomainsResult>"
	"</ListDomainsResponse>"
	"</soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:
					  @"<ListDomains xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "</ListDomains>\n", hashCode];	
    
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListDomains",actionURL];
	
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif	
	
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
	    
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/LoginUser",actionURL];
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
}

-(void)wsListMyTeams:(NSString *)hashCode
{
	recordHead = @"Team";	
    
   
#ifdef USING_LOCAL_DATA
	
	NSString *localData = 
	@"<soap:Body><ListMyTeamsResponse xmlns=\"http://tempuri.org/\">"
	"<ListMyTeamsResult><Team><IDTeam>2</IDTeam><TeamName>Administrators</TeamName></Team><Team><IDTeam>4</IDTeam><TeamName>Everyone - Todos os ServiÃ§os</TeamName></Team>"
	"<Team><IDTeam>1140</IDTeam><TeamName>Arquivo</TeamName></Team><Team><IDTeam>1159</IDTeam><TeamName>Grupo de testes da Ambisig</TeamName></Team>"
	"<Team><IDTeam>1214</IDTeam><TeamName>Grupo de Utilizadores do Expediente</TeamName></Team></ListMyTeamsResult></ListMyTeamsResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:	
					  @"<ListMyTeams xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"					 
					  "</ListMyTeams>\n",hashCode];
	
    
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListMyTeams",actionURL];
	NSLog(@"wsListMyTeams:%@",body);
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif	 
	
}

-(void)wsListMyDocumentTeams:(NSString *)hashCode StateTo:(NSString *)state Group:(NSString *)group
{
		
    recordHead = @"Team";	
    	
	
#ifdef USING_LOCAL_DATA
	
	NSString *localData = @"<soap:Body><ListWorkflowTeamToResponse xmlns=\"http://tempuri.org/\">"
	"<ListWorkflowTeamToResult><Team><IDTeam>1140</IDTeam><TeamName>Arquivo</TeamName></Team><Team><IDTeam>1159</IDTeam><TeamName>Grupo de testes da Ambisig</TeamName></Team><Team><IDTeam>1160</IDTeam><TeamName>Grupo de testes da Ambisig - User</TeamName></Team><Team><IDTeam>1214</IDTeam><TeamName>Grupo de Utilizadores do Expediente</TeamName></Team><Team><IDTeam>1195</IDTeam><TeamName>Grupo para testes</TeamName></Team><Team><IDTeam>1230</IDTeam><TeamName>gtestes</TeamName></Team></ListWorkflowTeamToResult></ListWorkflowTeamToResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:	
					  @"<ListWorkflowTeamTo xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<intWorkflowStateToID>%@</intWorkflowStateToID>\n"
					  "<strFilterGroupName>%@</strFilterGroupName>\n"
					  "</ListWorkflowTeamTo>\n",hashCode,state,group];
	
    
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListWorkflowTeamTo",actionURL];
	NSLog(@"wsListMyDocumentTeams:%@",body);
    
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif	
	
}

-(void)wsListWorkflowUsers:(NSString *)hashCode StateTo:(NSString *)state Team:(NSString *)teamNo
{
	//team id is the ListWorkflowTeamTo value, otherwise is 0
	recordHead = @"User";	
    	
	
#ifdef USING_LOCAL_DATA
	
	NSString *localData = @"<soap:Body><ListWorkflowUsersToResponse xmlns=\"http://tempuri.org/\">"
	"<ListWorkflowUsersToResult><User><IDUser>1198</IDUser><UserFullName>Dr. AntÃ³nio Ferreira</UserFullName></User><User><IDUser>1205</IDUser><UserFullName>Luis Ameida</UserFullName></User><User><IDUser>1225</IDUser><UserFullName>OneZero</UserFullName></User><User><IDUser>1211</IDUser><UserFullName>sevenuc - AMBISIG - ADMIN</UserFullName></User><User><IDUser>1163</IDUser><UserFullName>utilizador de teste GA</UserFullName></User></ListWorkflowUsersToResult></ListWorkflowUsersToResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:	
					  @"<ListWorkflowUsersTo xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<intWorkflowStateToID>%@</intWorkflowStateToID>\n"
					  "<intIDTeam>%@</intIDTeam>\n"
					  "</ListWorkflowUsersTo>\n",hashCode,state,teamNo];
	
    
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListWorkflowUsersTo",actionURL];
	NSLog(@"wsListWorkflowUsers:%@",body);
	
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif	
	
}

-(void)wsListMyDocuments:(NSString *)hashCode 
             PageRowSize:(NSInteger)rowsize  CurrentPage:(NSInteger)pageNo{
	page = pageNo;
	category = MyDocument;	
	recordHead = @"GDDocument";		
		
#ifdef USING_LOCAL_DATA
	
	NSString *localData = @"<soap:Body><ListMyDocumentsResponse xmlns=\"http://tempuri.org/\">"
	"<ListMyDocumentsResult><GDDocument><IDGDDocument>OihSrO1SmZG2eqC6dYjYtk%2fu89XGTbUI45tkd4LdNN6kmeF8yyYkYzjmeZGAt5vcjbmQ5GJgJ5B6aJrj3Iwiv%2bDHvUDG3q6JAuOClu1HO1ORNWQ1a2ft7yBghJLmV2xuUGJZKM20gfamzS%2f7tR0%2buJ6Hiez75PpgTVmTbvX939zN%2ff39%2fd3d3fg%3d</IDGDDocument><Subject>teets</Subject><Code>E/32/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>U1tBsFS%2f3y1XS2Tg7GlffzHiLBOkWQ7G58Rn5h60gS2cTKi7hSnxWCSq0su1rjHJszWWxaBPFTKgf%2fssfk%2fP2BbWphz9feBZZKaoFSu9lkH%2flH8yIFmnksAiNBnbtFqODyeQVMpMbNZvrCeO7IfEsQvCXvnvnkhGL38WPcg8qPTN%2ff39%2fd3d3fg%3d</IDGDDocument><Subject>teets</Subject><Code>E/33/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>Cs0LfRTb5WeFZVOjrasO8Wqdhe5MFeoTaIpYJZf1q1hR1u5Q2MrYmObq5ZNZdp2fE8f31mrORTBg0rTUHtiBZ1d%2bWXr0xPLYxAYoVUvFAhmS9h4QP0mpl7MjaB2OQUQBXyD5rWjGx3DDKO%2bJxCwOlGwyoQf2hba3cJ5FVKKdH9PN%2ff39%2fd3d3eI%3d</IDGDDocument><Subject>teets</Subject><Code>E/34/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>IgWfE6joqjY%2bVOYVmOXfA34Dx6VMS67f0oBL0TXuWHRweaEYZlARthecGTwgMDbVlriMinsgnCP6ORzzaIgYzkc%2f4k4zvGApE0b9QIvMraQz0tdL%2bg%2bbNZwgzTh%2ff8Plqbv1E0a8DKBl033ERAkCI9%2fjoWFyp5F9F9SiWoX6CdHN%2ff39%2fd3d3cw%3d</IDGDDocument><Subject>teets</Subject><Code>E/35/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>c539o%2bBuikhXe6AoGPzKeE4Lr43VWm7lgXStUVaauGueFQZRbx98HTSjmXZ3h4XokJezb2CbRWBOPHvV3HC0ti9FhlPf6CHSA6ZkfIfpl6Af4yukBjOnvZo7npD73QFnHJgYQs4kM1IHqeWCuALdTChPKEKkdGkDS8plAdvaOaXN%2ff39%2fd3d3cw%3d</IDGDDocument><Subject>teets</Subject><Code>E/36/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>W5pWPqcRdhjMWh3A44wnp2f3TJLWYdhE8RCf25Z2xdDmBglGXfkSR5ZgTnDFewnD2Jskq9KSBWNO2BuNHJ4FqTB5RqS4vzjAOPinUdQD99VQU%2bYcWTVhHAUDL3MovdRRKhXgMSA7iVr7RBoNewuWEJWAgGPVIrIjffTN%2fu341LbN%2ff39%2fd3d3cw%3d</IDGDDocument><Subject>teets</Subject><Code>E/37/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>XCJvsXzUQIepgDRwsT8QJDlCx2A6kN4BiyL25BPDQhG0wv8vPdXOKA%2bx5PH8j%2f9Aod58eXBVEp8P6WJO84rhEmDC9cf6bctsTOjTXf8a4%2bTp2A2X7dcQET0VO1sbUuk8hVf%2bbH6JoMtiwJmE7vwS7NdWgPJWGDbZ%2fAlXTFiEsQTN%2ff39%2fd3d3cw%3d</IDGDDocument><Subject>teets</Subject><Code>E/38/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>QuOmIVCDekbzz%2fcNhzmYrXhifzZ%2bv6fJN0k8x4q%2fS%2bq%2feyBxRvmvSPEdxLEaSGvgHS2Z6Pw%2bh6HB%2fdx7%2bdmaxhBX%2fjnAf6L5XPnxcsHCsL4gv2h5OVO%2bBASj6NVHJ4ZI42UXW9emM8U%2fmp4TCMI01AYsFKeP1Fy7gcEfyF2WbsnN%2ff39%2fd3d3Yo%3d</IDGDDocument><Subject>NotaDespesa</Subject><Code>E/55/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>nzps3wexrYFV8Wc0PKUF28ksQoGLTWBOjYz3jaTtDnmzeLtCXVM%2bD3lq%2bluaF1WPFUrtD1JsFGNtSYfkkCXfEtF3LSR1Su2im%2bwbQpBqN99X%2bbSwrcuvqaVYHg9UYjtOhdVrhUy1I%2biJvZ77QOBe4fTjzDY4NFLxL0JMzuQNyvHN%2ff39%2fd3d3Yo%3d</IDGDDocument><Subject>Quick Doc WPF</Subject><Code>E/63/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook />"
	"<CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>F4TXnUg%2fLWrCMM%2fvXsSW9lQ4sME%2bTYP0%2f4OyLrKcKFprtMUiMaIkXJ2leYVnD9nw9hN02ngU1k96I%2bgKq77g6zuII07owhFlsQ0sSdIFUwEawEy%2fF1Jt3NIs2stkym0Hc8%2fdahYSp3tMKy8xcl%2bYHxS2n5P6SHXzU1u9hcgmQSrN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>teste</Subject><Code>I/AMBISIG/1/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>DKzXY46MsKNvXl6iHNAdQ7BpWnXxkN3c4afVr6EptzHSVBdH%2bJqyA5csgAyDlo%2fb%2b4sfEQtkR2R2sm9tFf3WRZyWNKuqPvf%2bTG94YHPczddUyAk85r9Iwrn5pfomIJrK0BZn3uUQOEmevjTh%2f%2f55QIj5UnCaW0k%2fblAzPP1DUA7N%2ff39%2fQ%3d%3d</IDGDDocument><Subject>ComunicaÃ§Ãµes Internas</Subject><Code>I/AMBISIG/10/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>gHb5qVW173WypwuU1nwkoM3cUwx19TWjgw7BorsUkwZpzEYT5q4tXV9CCbG752cUTyHaoonUd9f3Rq9H2rsGmLImN9yMTKz%2b9xLTVF2avVfFDj6YYjpEbZE7jm69ORH2qZGfTHhV5TB5EHSoS0yi0QxeJLkZQs%2brVisbjonFUZ%2fN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>AlteraÃ§Ã£o de FÃ©rias</Subject><Code>I/AMBISIG/13/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>UV5WTEccsotvWvTRiE1N1yur38JYdtJh1x%2f8Kq3njLuYGtewaqE%2fXlYKQDpKCGn0xiTzfT05o3ZdeUqNbdWoMRkcAXFaGiS2MCBKf8epU%2fKDW77ZVdOmou22G174%2fXd1vk026r1biqhCXd44q8WGChg7ZZmIbUaldyuu1BwucujN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>AcumulaÃ§Ã£o de FÃ©rias</Subject><Code>I/AMBISIG/14/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>D007fg8qYDev2lIWieb4YWxBL3iyqrEvnASI5h1prG3x2xowe%2bbL%2bCzgU%2fPRfwm3GRcnOujIvH405xmxseVdOpauELTPo5HYBlHTt9bo68CjvlXp4f%2b6jsdftBAJYosHTBEe6%2fUzrSfqMI0102y686LQfIAvRKzP04%2fl6ick1OvN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>Despacho</Subject><Code>I/AMBISIG/15/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>GVWyOFD6QBda49FMs7bQU8uXTZ1hqqrL2SRZfVF3rkV1pjXoUxOmN3TDMM8JxWyafdojCjkTCGM%2fmHBf%2fWX2JKSAPOF2LrQZCrE2aCLlx0mlXMOpLhlBVv0EGk%2fT5FplVMIyfR%2fG0l96LLd9LRftF7U7NqWIT2mVcwx5Z3grLDbN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>AcumulaÃ§Ã£o de FÃ©rias</Subject><Code>I/AMBISIG/17/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>k2D3DAeEIziR1dxn2u7CK7UKPcS84KWEFBpOrON94uiTeq5KCuXuVrqNyXVVaL9eo5mD4IPKd7TAd9GMJgqXc1ppPKHOkOS8XuwoaUAS72iasqooUnQuBrtiBjpyXJwR31%2bXuhE1DjSnXxg2mawXhiP%2fM67Kj%2fZOZEJKuQYsTOnN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>AcumulaÃ§Ã£o de FÃ©rias</Subject><Code>I/AMBISIG/18/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>fvzVgCvfI6zkgA5GA1mH%2fWv7M%2bwqEBTYYEUOhXAMalHERoubtdU0pmmXdyHaOBqk2sa1g68GLZmrq0qDGxrR0ERZPsFTgfu3SxItetnInoUMuw5HwPXflLyvdOr%2bsxGFvv96QWdAQ8TBOoEDw8ZqDyRaHBBlrsc0peNXJArn4evN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>WebDoc 2010 - Impressora Virtual</Subject><Code>I/AMBISIG/19/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument>";
	"<GDDocument><IDGDDocument>ObFRTeQXrbJvpwX%2fCmAm523RqXIC3xeGA20IDA24q2Mq3%2bod01sT65jX0M7mDWvt3nLo7JxTlJaWu%2bF7CnnNR3S4%2f3ImVaAty1LNdDETWW6XiB4%2fxb6ExnYGfptFvHxHNvEJTNH27wLzTm7OTiU6eY5Xot5Vk2iUmV3Ji4AUbyPN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>sdsd</Subject><Code>I/AMBISIG/2/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>Kxh1ji5aBz3WNCUE4gQJxFgTs1%2b4tvyq%2bR2BUtUBk07fctEwelzdlRQ8aB%2baVTzxvQ%2fWWMCpE6MwG03hoh2ldjXeoVnzA0y0opCKfeumsS6gUUTQgqGLiePtte9D5JWt69gcli9KlBrETKYQ1joDN8woR1ggj4VbplYJfUUGmwfN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>ManutenÃ§Ã£o e Desenvolvimento em Projectos em .Net 1.1</Subject><Code>I/AMBISIG/20/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>lcWM2JivvEoFfZfRa2KP5xmb3yhjqAPWuU9XfsN2gKwcv9ymMuHOvtD5s7tQPsnF4czONlxgMIpdLH65FWKbUMBczJKa2V6B0gN8oFDK%2b5lFgXODPr%2bDDJ9ROTi9UsYjxILr33cfr2%2bVg4NoiaBoI%2bW6nydMzofraBnaFQb9rJjN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>ee</Subject><Code>I/AMBISIG/20/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>Lo7kgbo1%2faiR6qE26DmX%2bFGGnUl9uat74LFMrlQeKQ0wfVG%2f9k6%2fUomzEXCnmTPVQecN3POGG0VTO4VHd52mFzrQyJau4MVkJ1aaCbBfIG9DTgrcEYkyPezic7nxk7ej%2fzs2qpR3bv5z6VXvfBZbg9%2f5vvnwfTlz9%2fFafLwZTAXN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>ManutenÃ§Ã£o e Desenvolvimento em Projectos em .Net 1.1</Subject><Code>I/AMBISIG/21/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>SsltupEhc4Ph3TFkUTMFkCqkrexvkJRdQea3ULn9BBzzKY7bC2I7r9FphYip7bA1wWqrjZ6SdztcimIhRXDgCOyonUmBlpgj80b3CE4%2fWRf4Sur61Q8a%2beA2STLzsp5NWeVyT31wyrvMwcqOJg1uF7h%2f1EX1IlBBPf4WLVZ7nbrN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>[Convite] SessÃ£o Novas Empresas UPTEC</Subject><Code>I/AMBISIG/22/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>gkRrjbJprgtrAa0IcnA4BvBimEhy0dj3ualyYtzzPXdQRBH2wkHNdH%2fjoDw8ZDjCiSnLe0RPZ9iQ%2b25XvimjxVhfQ1DDmGOIsKK8qiPhRHmVNAMoSbTCm4%2b6jKf2B1oq%2fBKFPmVVYo7ktSlacvPc1j68QS7M1tn45RhqzUOuTIrN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>Portal AMLEI - Resposta a DÃºvidas</Subject><Code>I/AMBISIG/22/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>cFbXe4l%2fATaTj%2b9lUf3cuORQlAjxQoP38zm%2f%2bd0E%2fVK5qAKk8%2bGlVFznvw1rP7bR7yUZR5XTt60h3bimM0MZJGqatCZsn%2bgCzKvgUxBUUYzXNfgF%2b8RTtCm5ovjD97d0HeaHK07ijNKjlD5Sa3DQxsextoccsuEbVCk282sx4jrN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>JustificaÃ§Ã£o de Falta</Subject><Code>I/AMBISIG/23/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>kqaZ8KjxyEPQEt2dd%2bqk26K5K2d3%2fX1O7DIYe6rLXIMbWb0NL2bBJ3YZ%2beqRFDSniTeYU9jbdkE0DEZ7HJscphD%2beaoac6gldbLFpZR2WMQJ%2fGvB4kCVP80SxWpAtJ2T4Idx9gxFvl3bv0Qlx6BrOWk18fY0BUeNP0M7usGCLsDN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>[Post] Australian Letter Of The Year</Subject><Code>I/AMBISIG/24/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument></ListMyDocumentsResult></ListMyDocumentsResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:	
					  @"<ListMyDocuments xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<intPageRowSize>%d</intPageRowSize>\n"
					  "<intCurrentPage>%d</intCurrentPage>\n"
					  "</ListMyDocuments>\n",hashCode,rowsize,pageNo];
	
	NSLog(@"wsListMyDocuments:%@",body);
    
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListMyDocuments",actionURL];
    
	
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif
	
}

-(void)wsListMyDocumentsByDepartment:(NSString *)hashCode 
		PageRowSize:(NSInteger)rowsize  CurrentPage:(NSInteger)pageNo 
							  TeamID:(NSInteger)teamNo{
	page = pageNo;
	team = teamNo;
	category = MyTeamDocument;
	recordHead = @"GDDocument";	
	
#ifdef USING_LOCAL_DATA
	NSString *localData = @"<soap:Body><ListMyDocumentsResponse xmlns=\"http://tempuri.org/\">"
	"<ListMyDocumentsResult><GDDocument><IDGDDocument>OihSrO1SmZG2eqC6dYjYtk%2fu89XGTbUI45tkd4LdNN6kmeF8yyYkYzjmeZGAt5vcjbmQ5GJgJ5B6aJrj3Iwiv%2bDHvUDG3q6JAuOClu1HO1ORNWQ1a2ft7yBghJLmV2xuUGJZKM20gfamzS%2f7tR0%2buJ6Hiez75PpgTVmTbvX939zN%2ff39%2fd3d3fg%3d</IDGDDocument><Subject>teets</Subject><Code>E/32/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>U1tBsFS%2f3y1XS2Tg7GlffzHiLBOkWQ7G58Rn5h60gS2cTKi7hSnxWCSq0su1rjHJszWWxaBPFTKgf%2fssfk%2fP2BbWphz9feBZZKaoFSu9lkH%2flH8yIFmnksAiNBnbtFqODyeQVMpMbNZvrCeO7IfEsQvCXvnvnkhGL38WPcg8qPTN%2ff39%2fd3d3fg%3d</IDGDDocument><Subject>teets</Subject><Code>E/33/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>Cs0LfRTb5WeFZVOjrasO8Wqdhe5MFeoTaIpYJZf1q1hR1u5Q2MrYmObq5ZNZdp2fE8f31mrORTBg0rTUHtiBZ1d%2bWXr0xPLYxAYoVUvFAhmS9h4QP0mpl7MjaB2OQUQBXyD5rWjGx3DDKO%2bJxCwOlGwyoQf2hba3cJ5FVKKdH9PN%2ff39%2fd3d3eI%3d</IDGDDocument><Subject>teets</Subject><Code>E/34/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>IgWfE6joqjY%2bVOYVmOXfA34Dx6VMS67f0oBL0TXuWHRweaEYZlARthecGTwgMDbVlriMinsgnCP6ORzzaIgYzkc%2f4k4zvGApE0b9QIvMraQz0tdL%2bg%2bbNZwgzTh%2ff8Plqbv1E0a8DKBl033ERAkCI9%2fjoWFyp5F9F9SiWoX6CdHN%2ff39%2fd3d3cw%3d</IDGDDocument><Subject>teets</Subject><Code>E/35/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>c539o%2bBuikhXe6AoGPzKeE4Lr43VWm7lgXStUVaauGueFQZRbx98HTSjmXZ3h4XokJezb2CbRWBOPHvV3HC0ti9FhlPf6CHSA6ZkfIfpl6Af4yukBjOnvZo7npD73QFnHJgYQs4kM1IHqeWCuALdTChPKEKkdGkDS8plAdvaOaXN%2ff39%2fd3d3cw%3d</IDGDDocument><Subject>teets</Subject><Code>E/36/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>W5pWPqcRdhjMWh3A44wnp2f3TJLWYdhE8RCf25Z2xdDmBglGXfkSR5ZgTnDFewnD2Jskq9KSBWNO2BuNHJ4FqTB5RqS4vzjAOPinUdQD99VQU%2bYcWTVhHAUDL3MovdRRKhXgMSA7iVr7RBoNewuWEJWAgGPVIrIjffTN%2fu341LbN%2ff39%2fd3d3cw%3d</IDGDDocument><Subject>teets</Subject><Code>E/37/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>XCJvsXzUQIepgDRwsT8QJDlCx2A6kN4BiyL25BPDQhG0wv8vPdXOKA%2bx5PH8j%2f9Aod58eXBVEp8P6WJO84rhEmDC9cf6bctsTOjTXf8a4%2bTp2A2X7dcQET0VO1sbUuk8hVf%2bbH6JoMtiwJmE7vwS7NdWgPJWGDbZ%2fAlXTFiEsQTN%2ff39%2fd3d3cw%3d</IDGDDocument><Subject>teets</Subject><Code>E/38/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>QuOmIVCDekbzz%2fcNhzmYrXhifzZ%2bv6fJN0k8x4q%2fS%2bq%2feyBxRvmvSPEdxLEaSGvgHS2Z6Pw%2bh6HB%2fdx7%2bdmaxhBX%2fjnAf6L5XPnxcsHCsL4gv2h5OVO%2bBASj6NVHJ4ZI42UXW9emM8U%2fmp4TCMI01AYsFKeP1Fy7gcEfyF2WbsnN%2ff39%2fd3d3Yo%3d</IDGDDocument><Subject>NotaDespesa</Subject><Code>E/55/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>nzps3wexrYFV8Wc0PKUF28ksQoGLTWBOjYz3jaTtDnmzeLtCXVM%2bD3lq%2bluaF1WPFUrtD1JsFGNtSYfkkCXfEtF3LSR1Su2im%2bwbQpBqN99X%2bbSwrcuvqaVYHg9UYjtOhdVrhUy1I%2biJvZ77QOBe4fTjzDY4NFLxL0JMzuQNyvHN%2ff39%2fd3d3Yo%3d</IDGDDocument><Subject>Quick Doc WPF</Subject><Code>E/63/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook />"
	"<CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>F4TXnUg%2fLWrCMM%2fvXsSW9lQ4sME%2bTYP0%2f4OyLrKcKFprtMUiMaIkXJ2leYVnD9nw9hN02ngU1k96I%2bgKq77g6zuII07owhFlsQ0sSdIFUwEawEy%2fF1Jt3NIs2stkym0Hc8%2fdahYSp3tMKy8xcl%2bYHxS2n5P6SHXzU1u9hcgmQSrN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>teste</Subject><Code>I/AMBISIG/1/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>DKzXY46MsKNvXl6iHNAdQ7BpWnXxkN3c4afVr6EptzHSVBdH%2bJqyA5csgAyDlo%2fb%2b4sfEQtkR2R2sm9tFf3WRZyWNKuqPvf%2bTG94YHPczddUyAk85r9Iwrn5pfomIJrK0BZn3uUQOEmevjTh%2f%2f55QIj5UnCaW0k%2fblAzPP1DUA7N%2ff39%2fQ%3d%3d</IDGDDocument><Subject>ComunicaÃ§Ãµes Internas</Subject><Code>I/AMBISIG/10/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>gHb5qVW173WypwuU1nwkoM3cUwx19TWjgw7BorsUkwZpzEYT5q4tXV9CCbG752cUTyHaoonUd9f3Rq9H2rsGmLImN9yMTKz%2b9xLTVF2avVfFDj6YYjpEbZE7jm69ORH2qZGfTHhV5TB5EHSoS0yi0QxeJLkZQs%2brVisbjonFUZ%2fN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>AlteraÃ§Ã£o de FÃ©rias</Subject><Code>I/AMBISIG/13/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>UV5WTEccsotvWvTRiE1N1yur38JYdtJh1x%2f8Kq3njLuYGtewaqE%2fXlYKQDpKCGn0xiTzfT05o3ZdeUqNbdWoMRkcAXFaGiS2MCBKf8epU%2fKDW77ZVdOmou22G174%2fXd1vk026r1biqhCXd44q8WGChg7ZZmIbUaldyuu1BwucujN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>AcumulaÃ§Ã£o de FÃ©rias</Subject><Code>I/AMBISIG/14/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>D007fg8qYDev2lIWieb4YWxBL3iyqrEvnASI5h1prG3x2xowe%2bbL%2bCzgU%2fPRfwm3GRcnOujIvH405xmxseVdOpauELTPo5HYBlHTt9bo68CjvlXp4f%2b6jsdftBAJYosHTBEe6%2fUzrSfqMI0102y686LQfIAvRKzP04%2fl6ick1OvN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>Despacho</Subject><Code>I/AMBISIG/15/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>GVWyOFD6QBda49FMs7bQU8uXTZ1hqqrL2SRZfVF3rkV1pjXoUxOmN3TDMM8JxWyafdojCjkTCGM%2fmHBf%2fWX2JKSAPOF2LrQZCrE2aCLlx0mlXMOpLhlBVv0EGk%2fT5FplVMIyfR%2fG0l96LLd9LRftF7U7NqWIT2mVcwx5Z3grLDbN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>AcumulaÃ§Ã£o de FÃ©rias</Subject><Code>I/AMBISIG/17/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>k2D3DAeEIziR1dxn2u7CK7UKPcS84KWEFBpOrON94uiTeq5KCuXuVrqNyXVVaL9eo5mD4IPKd7TAd9GMJgqXc1ppPKHOkOS8XuwoaUAS72iasqooUnQuBrtiBjpyXJwR31%2bXuhE1DjSnXxg2mawXhiP%2fM67Kj%2fZOZEJKuQYsTOnN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>AcumulaÃ§Ã£o de FÃ©rias</Subject><Code>I/AMBISIG/18/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>fvzVgCvfI6zkgA5GA1mH%2fWv7M%2bwqEBTYYEUOhXAMalHERoubtdU0pmmXdyHaOBqk2sa1g68GLZmrq0qDGxrR0ERZPsFTgfu3SxItetnInoUMuw5HwPXflLyvdOr%2bsxGFvv96QWdAQ8TBOoEDw8ZqDyRaHBBlrsc0peNXJArn4evN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>WebDoc 2010 - Impressora Virtual</Subject><Code>I/AMBISIG/19/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument>";
	"<GDDocument><IDGDDocument>ObFRTeQXrbJvpwX%2fCmAm523RqXIC3xeGA20IDA24q2Mq3%2bod01sT65jX0M7mDWvt3nLo7JxTlJaWu%2bF7CnnNR3S4%2f3ImVaAty1LNdDETWW6XiB4%2fxb6ExnYGfptFvHxHNvEJTNH27wLzTm7OTiU6eY5Xot5Vk2iUmV3Ji4AUbyPN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>sdsd</Subject><Code>I/AMBISIG/2/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>Kxh1ji5aBz3WNCUE4gQJxFgTs1%2b4tvyq%2bR2BUtUBk07fctEwelzdlRQ8aB%2baVTzxvQ%2fWWMCpE6MwG03hoh2ldjXeoVnzA0y0opCKfeumsS6gUUTQgqGLiePtte9D5JWt69gcli9KlBrETKYQ1joDN8woR1ggj4VbplYJfUUGmwfN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>ManutenÃ§Ã£o e Desenvolvimento em Projectos em .Net 1.1</Subject><Code>I/AMBISIG/20/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>lcWM2JivvEoFfZfRa2KP5xmb3yhjqAPWuU9XfsN2gKwcv9ymMuHOvtD5s7tQPsnF4czONlxgMIpdLH65FWKbUMBczJKa2V6B0gN8oFDK%2b5lFgXODPr%2bDDJ9ROTi9UsYjxILr33cfr2%2bVg4NoiaBoI%2bW6nydMzofraBnaFQb9rJjN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>ee</Subject><Code>I/AMBISIG/20/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>Lo7kgbo1%2faiR6qE26DmX%2bFGGnUl9uat74LFMrlQeKQ0wfVG%2f9k6%2fUomzEXCnmTPVQecN3POGG0VTO4VHd52mFzrQyJau4MVkJ1aaCbBfIG9DTgrcEYkyPezic7nxk7ej%2fzs2qpR3bv5z6VXvfBZbg9%2f5vvnwfTlz9%2fFafLwZTAXN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>ManutenÃ§Ã£o e Desenvolvimento em Projectos em .Net 1.1</Subject><Code>I/AMBISIG/21/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>SsltupEhc4Ph3TFkUTMFkCqkrexvkJRdQea3ULn9BBzzKY7bC2I7r9FphYip7bA1wWqrjZ6SdztcimIhRXDgCOyonUmBlpgj80b3CE4%2fWRf4Sur61Q8a%2beA2STLzsp5NWeVyT31wyrvMwcqOJg1uF7h%2f1EX1IlBBPf4WLVZ7nbrN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>[Convite] SessÃ£o Novas Empresas UPTEC</Subject><Code>I/AMBISIG/22/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>gkRrjbJprgtrAa0IcnA4BvBimEhy0dj3ualyYtzzPXdQRBH2wkHNdH%2fjoDw8ZDjCiSnLe0RPZ9iQ%2b25XvimjxVhfQ1DDmGOIsKK8qiPhRHmVNAMoSbTCm4%2b6jKf2B1oq%2fBKFPmVVYo7ktSlacvPc1j68QS7M1tn45RhqzUOuTIrN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>Portal AMLEI - Resposta a DÃºvidas</Subject><Code>I/AMBISIG/22/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>cFbXe4l%2fATaTj%2b9lUf3cuORQlAjxQoP38zm%2f%2bd0E%2fVK5qAKk8%2bGlVFznvw1rP7bR7yUZR5XTt60h3bimM0MZJGqatCZsn%2bgCzKvgUxBUUYzXNfgF%2b8RTtCm5ovjD97d0HeaHK07ijNKjlD5Sa3DQxsextoccsuEbVCk282sx4jrN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>JustificaÃ§Ã£o de Falta</Subject><Code>I/AMBISIG/23/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument><GDDocument><IDGDDocument>kqaZ8KjxyEPQEt2dd%2bqk26K5K2d3%2fX1O7DIYe6rLXIMbWb0NL2bBJ3YZ%2beqRFDSniTeYU9jbdkE0DEZ7HJscphD%2beaoac6gldbLFpZR2WMQJ%2fGvB4kCVP80SxWpAtJ2T4Idx9gxFvl3bv0Qlx6BrOWk18fY0BUeNP0M7usGCLsDN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>[Post] Australian Letter Of The Year</Subject><Code>I/AMBISIG/24/2010</Code><EntityDoc /><Reference /><RegistryDate>0001-01-01T00:00:00</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel /><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>0</IDGDDocumentType><GDDocumentType /><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>0</IDBook><GDBook /><CODGDBook /><EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GDDocument></ListMyDocumentsResult></ListMyDocumentsResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else	
	NSString *body = [NSString stringWithFormat:	
					  @"<ListMyTeamDocuments xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<intPageRowSize>%d</intPageRowSize>\n"
					  "<intCurrentPage>%d</intCurrentPage>\n"
					  "<intIDTeam>%d</intIDTeam>\n"
					  "</ListMyTeamDocuments>\n",hashCode,rowsize,pageNo,teamNo];
	
	NSLog(@"wsListMyDocumentsByDepartment:%@",body);
    
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListMyTeamDocuments",actionURL];
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
	
#endif
	
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
	
    
	NSString *url = [NSString stringWithFormat:@"%@/WSDownload.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/GetAttachmentFile",actionURL];
    [self doWebService: body sSoapXML:url sSOAPAction:action];
	
	//return:<GetAttachmentFileResult>base64Binary</GetAttachmentFileResult>
	[self createProgressionAlertWithMessage:@"download Attachment ..." withActivity:NO];
	
}

-(void)wsUpLoadFile:(NSString *)data{
	recordHead = @"UploadFileResult";	
	   
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
	
	
#ifdef USING_LOCAL_DATA
	NSString *localData = @"<soap:Body><GetDocumentHistoryResumedResponse xmlns=\"http://tempuri.org/\">"
	"<GetDocumentHistoryResumedResult><MovimentHistory><IDMovimentHistory>462</IDMovimentHistory><MovimentHistory>administrator --&gt; administrator || Obs: Movimento AutomÃ¡tico</MovimentHistory><DateHistory>2010-09-17T12:09:08</DateHistory></MovimentHistory><MovimentHistory><IDMovimentHistory>496</IDMovimentHistory><MovimentHistory>administrator --&gt; sevenuc || Obs: test"
	"</MovimentHistory><DateHistory>2010-10-25T09:47:38</DateHistory></MovimentHistory></GetDocumentHistoryResumedResult></GetDocumentHistoryResumedResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:
					  @"<GetDocumentHistoryResumed xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<strDocumentIDEncrypted>%@</strDocumentIDEncrypted>\n"
					  "</GetDocumentHistoryResumed>\n", hashCode,document];	
    
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/GetDocumentHistoryResumed",actionURL];
	
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif
	
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
    
	NSString *url = [NSString stringWithFormat:@"%@/WSCreate.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/FowardWkf",actionURL];	
	NSLog(@"wsDoWorkFlow:%@",body);
    [self doWebService: body sSoapXML:url sSOAPAction:action];
}

-(void)wsListIndicators:(NSString *)hashCode
{
	recordHead = @"Indicator";	
		
   
#ifdef USING_LOCAL_DATA
	
	NSString *localData = @"<soap:Body><GetIndicatorsResponse xmlns=\"http://tempuri.org/\">"
	"<GetIndicatorsResult><Indicator><IdIndicator>4</IdIndicator><Title>Docs Dept. 1</Title><Description>Documentos despachados pelo Departamento 1</Description><isPercent>true</isPercent><Limits><double>0</double><double>0.33</double><double>0.66</double><double>300</double><double>5000</double></Limits><ActualState>FIVELIMITS_STATETHREE</ActualState><Value>0.726</Value></Indicator><Indicator><IdIndicator>5</IdIndicator><Title>Docs Dept. 2</Title><Description>Documentos despachados pelo Departamento 2</Description><isPercent>false</isPercent><Limits><double>0</double><double>100</double><double>200</double><double>300</double><double>5000</double></Limits><ActualState>FIVELIMITS_STATETWO</ActualState><Value>124</Value></Indicator><Indicator><IdIndicator>6</IdIndicator><Title>Docs Dept. 3</Title><Description>Documentos despachados pelo Departamento 3</Description><isPercent>false</isPercent><Limits><double>0</double><double>200</double><double>300</double><double>5000</double></Limits><ActualState>FOURLIMITS_STATETHREE</ActualState><Value>439</Value></Indicator><Indicator><IdIndicator>7</IdIndicator><Title>Meta XPTO</Title><Description>Meta XPTO cumprida</Description><isPercent>true</isPercent><Limits><double>0</double><double>0.4</double><double>0.8</double><double>1</double></Limits><ActualState>FOURLIMITS_STATEONE</ActualState><Value>0.12</Value></Indicator><Indicator><IdIndicator>8</IdIndicator><Title>Meta XYZ</Title><Description>Meta XYZ cumprido</Description><isPercent>true</isPercent><Limits><double>0</double><double>0.4</double><double>0.8</double><double>1</double></Limits><ActualState>FOURLIMITS_STATETHREE</ActualState><Value>0.8676</Value></Indicator><Indicator><IdIndicator>9</IdIndicator><Title>Trmnt Docs</Title><Description>Tempo mÃ©dio de tratamento de documentos face ao estimado</Description><isPercent>true</isPercent><Limits><double>0</double><double>0.2</double><double>0.4</double><double>0.6</double></Limits><ActualState>FOURLIMITS_STATETWO</ActualState><Value>0.34</Value></Indicator></GetIndicatorsResult></GetIndicatorsResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:
					  @"<GetIndicators xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"					 
					  "</GetIndicators>\n", hashCode];	
    
	NSString *url = [NSString stringWithFormat:@"%@/WSStats.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/GetIndicators",actionURL];
	
	NSLog(@"wsListIndicators:%@",body);
	
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif	
	
}

-(void)wsGetIndicatorDetails:(NSString *)hashCode Indicator:(NSString *)indicatorId {
		
	recordHead = @"GetIndicatorDetailsResult";	
	NSString *body = [NSString stringWithFormat:
					  @"<GetIndicatorDetails xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"	
					  "<intIndicatorID>%@</intIndicatorID>\n"
					  "</GetIndicatorDetails>\n", hashCode,indicatorId];	
    
	NSString *url = [NSString stringWithFormat:@"%@/WSStats.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/GetIndicatorDetails",actionURL];
	NSLog(@"wsListIndicators:%@",body);
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
}

-(void)wsGetIndicatorDetailsImage:(NSString *)hashCode Indicator:(NSString *)indicatorId {

	recordHead = @"GetIndicatorDetailsImageResult";	
	
	
#ifdef USING_LOCAL_DATA
	
	NSString *localData = @"<soap:Body><GetIndicatorDetailsImageResponse xmlns=\"http://tempuri.org/\">"
	"<GetIndicatorDetailsImageResult>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</GetIndicatorDetailsImageResult></GetIndicatorDetailsImageResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:
					  @"<GetIndicatorDetailsImage xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"	
					  "<intIndicatorID>%@</intIndicatorID>\n"
					  "</GetIndicatorDetailsImage>\n", hashCode,indicatorId];	
	
	NSString *url = [NSString stringWithFormat:@"%@/WSStats.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/GetIndicatorDetailsImage",actionURL];
	NSLog(@"wsListIndicators:%@",body);
	
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif
	
}


-(void)wsTotalMyDocuments:(NSString *)hashCode{
	recordHead = @"TotalMyDocumentsResult";			
	
	
#ifdef USING_LOCAL_DATA
	
	NSString *localData = @"<soap:Body><TotalMyDocumentsResponse xmlns=\"http://tempuri.org/\">"
	"<TotalMyDocumentsResult>51</TotalMyDocumentsResult></TotalMyDocumentsResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:
					  @"<TotalMyDocuments xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "</TotalMyDocuments>\n", hashCode];	
	
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/TotalMyDocuments",actionURL];
	
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif	
}

-(void)wsTotalMyTeamDocuments:(NSString *)hashCode TeamId:(NSString *)teamNo{
	recordHead = @"TotalMyTeamDocumentsResult";			
	
#ifdef USING_LOCAL_DATA
	
	NSString *localData = @"<soap:Body><TotalMyDocumentsResponse xmlns=\"http://tempuri.org/\">"
	"<TotalMyDocumentsResult>51</TotalMyDocumentsResult></TotalMyDocumentsResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:
					  @"<TotalMyTeamDocuments xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<intIDTeam>%@</intIDTeam>\n"
					  "</TotalMyTeamDocuments>\n", hashCode, teamNo];	
	
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/TotalMyTeamDocuments",actionURL];
		
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif	
	
}


-(void)wsListWorkflowStates:(NSString *)hashCode{
	recordHead = @"WorkFlowState";			
	
		
#ifdef USING_LOCAL_DATA
	
	NSString *localData = 
	@"<soap:Body><ListWorkflowStatesResponse xmlns=\"http://tempuri.org/\">"
	"<ListWorkflowStatesResult><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>ActualizaÃ§Ã£o do RelÃ³gio de Ponto</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>ActualizaÃ§Ã£o do RelÃ³gio de Ponto[2]</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>ActualizaÃ§Ã£o do RelÃ³gio de Ponto[3]</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda AprovaÃ§Ã£o de 1Âº NÃ­vel</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda AprovaÃ§Ã£o de 2Âº NÃ­vel</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda Arquivo</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda AutorizaÃ§Ã£o de Pagamento</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda DecisÃ£o</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda Despacho</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda Disponibilidade Financeira</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda DistribuiÃ§Ã£o</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda DistribuiÃ§Ã£o de CÃ³pias pelos Intervinientes e Tesoureiro</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda DistribuiÃ§Ã£o para CD </WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda envio</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState>"
	"<WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda Envio de Documento</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda Envio de Resposta</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda InformaÃ§Ã£o</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda Pagamento</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda Parecer</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda Resposta</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda VerificaÃ§Ã£o</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aguarda VerificaÃ§Ã£o de Dados</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>AlteraÃ§Ã£o de FÃ©rias</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>AnÃ¡lise do Processo</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Anulado</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Aprovada</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Arquivado</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Arquivo</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Concluido</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState>"
	"<WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>ConcluÃ­do</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>ConcluÃ­do em Processo</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>ConcluÃ­do em Processo de Obras</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Despacho pela Directora Regional</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Despacho/Parecer do Sup. HierÃ¡rquico</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Disponibilizado</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Elabora e Envia OfÃ­cio</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Elabora e Envia OfÃ­cio[1]</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>ElaboraÃ§Ã£o de Proposta de Deferimento</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>ElaboraÃ§Ã£o do Mapa de FÃ©rias</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>ElaboraÃ§Ã£o Proposta de Indeferimento</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Em AnÃ¡lise</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Em AnÃ¡lise TÃ©cnica</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Em ElaboraÃ§Ã£o</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Em ServiÃ§o</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow>"
	"<IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Enviado</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Escolha de novo PerÃ­odo de FÃ©rias</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Escolha do PerÃ­odo de FÃ©rias</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>FÃ©rias Autorizadas</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>FÃ©rias Gozadas</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>HomologaÃ§Ã£o</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>IncluÃ­do em Processo</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>InformaÃ§Ã£o do SPAV do NÂº de Dias de FÃ©rias</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>NÃ£o Aprovada</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>NotificaÃ§Ã£o do Trabalhador</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>NotificaÃ§Ã£o do Trabalhador[2]</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Parecer da DAGOE</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Parecer do Sup. HierÃ¡rquico</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Pedido de AcumulaÃ§Ã£o de FunÃ§Ãµes</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState>"
	"<WorkflowLabel>Pedido Registado</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Pendente</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Preenchimento do Retorno ao ServiÃ§o</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Registada</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Registado</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Registado</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Registo Total ou Parcial</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Remetido a Admin</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Requisitado por ServiÃ§o ao Arquivo</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>ServiÃ§o</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>0</IDWorkflowState><WorkflowLabel>Solicitar ao Arquivo</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState></ListWorkflowStatesResult></ListWorkflowStatesResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:
					  @"<ListWorkflowStates xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "</ListWorkflowStates>\n", hashCode];	
	
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListWorkflowStates",actionURL];
	NSLog(@"wsListWorkflowStates:%@",body);
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif	
	
}

-(void)wsListWorkflowStatesTo:(NSString *)hashCode DocumentID:(NSString *)document
{
	 recordHead = @"WorkFlowState";	
	
#ifdef USING_LOCAL_DATA
	NSString *localData = @"<soap:Body><ListWorkflowStateToResponse xmlns=\"http://tempuri.org/\">"
	"<ListWorkflowStateToResult><WorkFlowState><IDWorkflowState>11</IDWorkflowState><WorkflowLabel>Aguarda Envio de Resposta</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>13</IDWorkflowState><WorkflowLabel>ConcluÃ­do</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>10</IDWorkflowState><WorkflowLabel>IncluÃ­do em Processo</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState><WorkFlowState><IDWorkflowState>9</IDWorkflowState><WorkflowLabel>ServiÃ§o</WorkflowLabel><Question /><IDWorkflow>0</IDWorkflow><IDStateWorkflow>0</IDStateWorkflow></WorkFlowState></ListWorkflowStateToResult></ListWorkflowStateToResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:
					  @"<ListWorkflowStateTo xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<strDocumentIDEncrypted>%@</strDocumentIDEncrypted>\n"
					  "</ListWorkflowStateTo>\n", hashCode, document];	
	
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListWorkflowStateTo",actionURL];
	NSLog(@"wsListWorkflowStatesTo:%@",body);
	
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif
}

-(void)wsListDirections:(NSString *)hashCode{
		
	recordHead = @"GDBook";	
				
#ifdef USING_LOCAL_DATA
	
	NSString *localData = 
	@"<soap:Body><ListBooksResponse xmlns=\"http://tempuri.org/\">"
	"<ListBooksResult><GDBook><IDBook>3</IDBook>"
	"<GDBook>Documento Entrada</GDBook><CODGDBook>E</CODGDBook><EntityRequired>True</EntityRequired><VisibleInPrinter>True</VisibleInPrinter><VisibleInGD>True</VisibleInGD><Process>False</Process><IDGDBookDirection>ENTRADA</IDGDBookDirection></GDBook>"
	"<GDBook><IDBook>1</IDBook><GDBook>Documento Interno</GDBook><CODGDBook>I</CODGDBook><EntityRequired>False</EntityRequired><VisibleInPrinter>True</VisibleInPrinter><VisibleInGD>True</VisibleInGD><Process>False</Process><IDGDBookDirection>INTERNO</IDGDBookDirection></GDBook>"
	"<GDBook><IDBook>2</IDBook><GDBook>Documento SaÃ­da</GDBook><CODGDBook>S</CODGDBook><EntityRequired>True</EntityRequired><VisibleInPrinter>True</VisibleInPrinter><VisibleInGD>True</VisibleInGD><Process>False</Process><IDGDBookDirection>SAIDA</IDGDBookDirection></GDBook>"
	"</ListBooksResult></ListBooksResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:
					  @"<ListBooks xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "</ListBooks>\n", hashCode];	
    
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListBooks",actionURL];
	NSLog(@"wsListDirections:%@",body);
	
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif	   
	
}	

-(void)wsGetDocumentDataResumed:(NSString *)hashCode DocumentID:(NSString *)document
{
	recordHead = @"GetDocumentDataResumedResult";	
	
	
#ifdef USING_LOCAL_DATA
	
	NSString *localData = @"<soap:Body><GetDocumentDataResumedResponse xmlns=\"http://tempuri.org/\">"
	"<GetDocumentDataResumedResult><IDGDDocument>ltWqfSUmHNWnyXPaV86UOSjT23wLeNXs3Q3WxUd56FQoK%2bsCUlbaVpVLpfTP57mc8R1WTFWrp7X4tSI8hhRkY%2fnmIhozQSIrD%2bYxeIXwl0hhs2kUMhbTmq9oYB8nHm1t1XDKJPfBOQkhTa9j53XO7gJ9%2ftZs8ZtRbaa24v4qEn%2fN%2ff39%2fQ%3d%3d</IDGDDocument><Subject>teets</Subject><Code>E/32/2010</Code><EntityDoc>Abel Espirito Santo</EntityDoc><Reference /><RegistryDate>2010-08-30T16:35:34</RegistryDate><DeliveredDate>0001-01-01T00:00:00</DeliveredDate><WorkflowState><IDWorkflowState>9</IDWorkflowState><WorkflowLabel>ServiÃ§o</WorkflowLabel><Question>DecisÃ£o ?</Question><IDWorkflow>0</IDWorkflow><IDStateWorkflow>5</IDStateWorkflow></WorkflowState><DocumentType><IDGDDocumentType>2</IDGDDocumentType><GDDocumentType>Fax</GDDocumentType><CODGDDocumentType>F</CODGDDocumentType><IDClassifier>0</IDClassifier><IDWorkflow>2</IDWorkflow><IDGDBook>3</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></DocumentType><GDBook><IDBook>3</IDBook><GDBook>Documento Entrada</GDBook><CODGDBook>E</CODGDBook>"
	"<EntityRequired>False</EntityRequired><VisibleInPrinter>False</VisibleInPrinter><VisibleInGD>False</VisibleInGD><Process>False</Process><IDGDBookDirection>NONE</IDGDBookDirection></GDBook><GDClassifier><IDGDClassifier>0</IDGDClassifier><IDGDClassifierParent>0</IDGDClassifierParent><GDClassifier /><CodGDClassifier /><Description /><InActive>false</InActive><Limited>False</Limited></GDClassifier><Entity><IDEntity>0</IDEntity><CodEntity /><TaxPayerNumber /><Entity /><Address /><PostalCode /><Locale /><Phone /><Fax /><Email /><Visible>false</Visible><History>false</History></Entity><Deadline>0</Deadline><DocumentState>NoState</DocumentState><IDDocumentHolder>0</IDDocumentHolder><DocumentHolder /><Delegated>false</Delegated></GetDocumentDataResumedResult></GetDocumentDataResumedResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:
					  @"<GetDocumentDataResumed xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<strDocumentIDEncrypted>%@</strDocumentIDEncrypted>\n"
					  "</GetDocumentDataResumed>\n", hashCode, document];	
	
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/GetDocumentDataResumed",actionURL];
    
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif
	
}

-(void)wsListDocumentAttachments:(NSString *)hashCode DocumentID:(NSString *)document
{	
	recordHead = @"DocFile";	
		
#ifdef USING_LOCAL_DATA
	
	NSString *localData = @"<soap:Body><ListDocumentFilesResponse xmlns=\"http://tempuri.org/\">"
	"<ListDocumentFilesResult><DocFile><IDFile>ZjlcWt4uZG9AkXZ%2bR2W1T6Y16%2bM1or3W8KWMW8guOwxlhKXdIsGhHNXvLh5pagzZrm%2fsiANCh9sVORzxARAZcR88d2jOw1isuXlzRIstfKhDuzexeUfYhKSRx57qQHl93lnjC7WMbUGiBw9FTL7yVjYuxSfdcMDTy8mQ0hdxxAXN%2ff39%2fQ%3d%3d</IDFile><FileName>teets</FileName><Extension>txt</Extension><IsAttachment>false</IsAttachment></DocFile></ListDocumentFilesResult></ListDocumentFilesResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:
					  @"<ListDocumentFiles xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<strDocumentIDEncrypted>%@</strDocumentIDEncrypted>\n"
					  "</ListDocumentFiles>\n", hashCode, document];	
    
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListDocumentFiles",actionURL];
	NSLog(@"wsListDocumentAttachments:%@",body);
    	
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif
}

-(void)wsListDocumentTypes:(NSString *)hashCode 
		DocumentID:(NSString *)document{
	recordHead = @"GDDocumentType";		
	
	    
#ifdef USING_LOCAL_DATA
	
	NSString *localData = 
	@"<soap:Body><ListDocumentTypesResponse xmlns=\"http://tempuri.org/\">"
	"<ListDocumentTypesResult><GDDocumentType><IDGDDocumentType>3</IDGDDocumentType><GDDocumentType>Carta</GDDocumentType><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></GDDocumentType>"
	"<GDDocumentType><IDGDDocumentType>8</IDGDDocumentType><GDDocumentType>Carta</GDDocumentType><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></GDDocumentType>"
	"<GDDocumentType><IDGDDocumentType>11</IDGDDocumentType><GDDocumentType>Comercial</GDDocumentType><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></GDDocumentType>"
	"<GDDocumentType><IDGDDocumentType>4</IDGDDocumentType><GDDocumentType>ComunicaÃ§Ã£o Interna</GDDocumentType><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></GDDocumentType>"
	"<GDDocumentType><IDGDDocumentType>9</IDGDDocumentType><GDDocumentType>Convite</GDDocumentType><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></GDDocumentType><GDDocumentType>"
	"<IDGDDocumentType>10</IDGDDocumentType><GDDocumentType>Convite</GDDocumentType><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></GDDocumentType><GDDocumentType>"
	"<IDGDDocumentType>5</IDGDDocumentType><GDDocumentType>Despacho</GDDocumentType><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></GDDocumentType><GDDocumentType>"
	"<IDGDDocumentType>2</IDGDDocumentType><GDDocumentType>Fax</GDDocumentType><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></GDDocumentType><GDDocumentType>"
	"<IDGDDocumentType>7</IDGDDocumentType><GDDocumentType>Fax</GDDocumentType><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></GDDocumentType><GDDocumentType>"
	"<IDGDDocumentType>1</IDGDDocumentType><GDDocumentType>OfÃ­cio</GDDocumentType><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></GDDocumentType><GDDocumentType>"
	"<IDGDDocumentType>6</IDGDDocumentType><GDDocumentType>OfÃ­cio</GDDocumentType><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></GDDocumentType><GDDocumentType>"
	"<IDGDDocumentType>12</IDGDDocumentType><GDDocumentType>Oficio Digital</GDDocumentType><CODGDDocumentType /><IDClassifier>0</IDClassifier><IDWorkflow>0</IDWorkflow><IDGDBook>0</IDGDBook><VisibleInGD>false</VisibleInGD><VisibleInPrinter>false</VisibleInPrinter></GDDocumentType>"
	"</ListDocumentTypesResult></ListDocumentTypesResponse></soap:Body></soap:Envelope>";
	
	[self doLocalResponse:localData];
#else
	NSString *body = [NSString stringWithFormat:
					  @"<ListDocumentTypes xmlns=\"http://tempuri.org/\">\n"
					  "<strHashCode>%@</strHashCode>\n"
					  "<intBookID>%@</intBookID>\n"
					  "</ListDocumentTypes>\n", hashCode,document];	
    
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListDocumentTypes",actionURL];
	NSLog(@"wsListDocumentTypes:%@",body);
    [self doWebService: body sSoapXML:url sSOAPAction:action];	
#endif	   
	
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
    
	NSString *url = [NSString stringWithFormat:@"%@/WSGetInfo.asmx",serviceURL];
	NSString *action = [NSString stringWithFormat:@"%@/ListDocuments",actionURL];
	
	NSLog(@"wsAdvancedSearch:%@",body);
	
    [self doWebService: body sSoapXML:url sSOAPAction:action];		
	
}


#pragma mark -
#pragma mark Local Data Response 
- (void)doLocalResponse:(NSString *)localStr{
	NSString *fixedHeadLine = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">";
	NSMutableString *mutableStr = [[NSMutableString alloc] initWithCapacity:[fixedHeadLine length] + [localStr length]];
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
	[mutableStr appendString:fixedHeadLine];
	[mutableStr appendString:localStr];		
	NSData *data = [mutableStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];	
    [self asyncRequestSucceeded:data userInfo:userInfo];
	[mutableStr release];
	[userInfo release];	
}


#pragma mark -
#pragma mark AsyncNet API

- (void)asyncRequestSucceeded:(NSData *)data
						  userInfo:(NSDictionary *)userInfo
{
	if(data == nil)	return;
	
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
