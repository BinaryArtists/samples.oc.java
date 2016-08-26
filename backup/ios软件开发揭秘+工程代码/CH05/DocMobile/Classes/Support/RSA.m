//
//  SimpleCrypto.m
//

#import "RSA.h"
#import "base64.h"
#import "NSData+Base64.h"

#define PRIVATE_KEY  0
#define PRIVATE_KEY_DATA "-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKBgQC63DnkIOVCRGA6yZeAERke4rsq6WgmCyDncvew5VUfXO5DT3YY\nEMPm2fkLkApjGiUynyOsPlMBy7pKw1kr1os5hlHaAt6bRbb/7pr1fCBK7M5fY+ol\nQ3onYKFU0VcFBgz2XyF7RJsIPkC7N+3s4do9gmZpAqbiByXxRswo/AbnVQIDAQAB\nAoGBAIJrn4RYaWt9KeUeOz3JsUzbV2O2EVksP0UL+1FeX7FKPYqBdZ2KZhFEZgzp\n9jYBU6EnbdCUl38TYO05t41fa0AC2XWJn+xWzPrba3ipZmzuWncv2eSi5xxDenwc\nPvl1Lcn1EF/YrcKSMuMPRZqLTCP1wx2+7nWEMsCpFY1JIrfBAkEA7eqkmvDR2xyU\nw6y2jHpDJ68WUULmRrSSHC+d7HKSJaiUPm5yOGS+f5PWVDVvi+rIZw/sGbqiAU8e\nRmdhlrsOOQJBAMkQImqNE96f6pmm7vSrEMD5EC0NU09P3mOrSI76d6qXLtXtRL8U\n8psbOtGmrqXfnKzjbKgz2b8p6BoGYmr4of0CQHo8DrwINFmV0pzB9Lwx6KTP4PB5\nJaR4C4VttX6Q0qOEfD2jMw3kPLeBNiHnnlrNko7Y8F27tJZlltFnNg1iJ4kCQEHJ\n6bj7mHjL0rOcD6w3HTBHTqevKIdXFul97iv6gJVtCoItNMVhUVC3RDO9WoAj/twD\nPlZ7QNBwIeYCGMnvuPECQBNdjWiKAKbsYWx4m4W2Kf6GOMI5QXchdEAl3EyNFBHd\nxiqeNlgl+kEEwhWTC7Z/4zOv4rPMJfmKWiVjG1kll30=\n-----END RSA PRIVATE KEY-----"

#define PUBLIC_KEY  1
//#define PUBLIC_KEY_DATA "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC63DnkIOVCRGA6yZeAERke4rsq\n6WgmCyDncvew5VUfXO5DT3YYEMPm2fkLkApjGiUynyOsPlMBy7pKw1kr1os5hlHa\nAt6bRbb/7pr1fCBK7M5fY+olQ3onYKFU0VcFBgz2XyF7RJsIPkC7N+3s4do9gmZp\nAqbiByXxRswo/AbnVQIDAQAB\n-----END PUBLIC KEY-----"
#define PUBLIC_KEY_DATA "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDJpkXS9QaJ/yvtUA7hTl2LBUl3\nbfkgXLWym/AELcZ5bz4Vu5c/gj1lfvWHXxbH25n9TqhEiABysaiJz+hVcENWEHpw\nYfV/JBnUC1ds4V/XHVR8F2hfk8B9hITa3QzZIwZIVkooFA1fcuajmfQ8zoLnr+Ad\nZb1zUDFjBv2ZexfjGwIDCgSZ\n-----END PUBLIC KEY-----"

#define PUBLIC_CERTIFICATE 2
#define PUBLIC_CERTIFICATE_DATA "-----BEGIN CERTIFICATE-----\nMIICATCCAWoCCQDz/9kR2AdCuzANBgkqhkiG9w0BAQUFADBFMQswCQYDVQQGEwJB\nVTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50ZXJuZXQgV2lkZ2l0\ncyBQdHkgTHRkMB4XDTA4MDUxNDE3MDE0NVoXDTE4MDUxMjE3MDE0NVowRTELMAkG\nA1UEBhMCQVUxEzARBgNVBAgTClNvbWUtU3RhdGUxITAfBgNVBAoTGEludGVybmV0\nIFdpZGdpdHMgUHR5IEx0ZDCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAutw5\n5CDlQkRgOsmXgBEZHuK7KuloJgsg53L3sOVVH1zuQ092GBDD5tn5C5AKYxolMp8j\nrD5TAcu6SsNZK9aLOYZR2gLem0W2/+6a9XwgSuzOX2PqJUN6J2ChVNFXBQYM9l8h\ne0SbCD5Auzft7OHaPYJmaQKm4gcl8UbMKPwG51UCAwEAATANBgkqhkiG9w0BAQUF\nAAOBgQAJ2sY6JDVPQ2jfjrTRrNyJdO4jobk+2AysI1CtsLLczsPNaokEgj71Y1ui\nL2/3Etli1RMT2/9ni4boRCrWmvJTf41fxzX/ETATDOYRGfQZb20rutxLDmXB2ene\nLDE5ha8P/JkJ/fiZYtG2A8ZzpRdC5B16w2rrH5OSDQrIyi+3xA==\n-----END CERTIFICATE-----"

#define MAN_OAEP_PADDING 42
#define STATIC_KEY 1
#define BUFFSIZE 1024
#define TRY_ENCRYPT_COUNT 6

typedef struct {
	size_t len;
	u_char   *data;
} ngx_str_t;

@interface SimpleCrypto (PrivateAPI)
- (void)setupOpenSSL;
- (void)cleanupOpenSSL;
@end

// SimpleCrypto object
@implementation SimpleCrypto

- (id)init
{
    if((self = [super init]))
	{
        // Call private method to handle the setup for internal OpenSSL stuff
		[self setupOpenSSL];
    }
    return self;
}

- (void)setupOpenSSL
{
	OpenSSL_add_all_algorithms();		
	ERR_load_crypto_strings();
}

- (void)dealloc
{
    // Cleanup all OpenSSL stuff
	[self cleanupOpenSSL];	
	[clearText release];
	[publicKey release];
	[privateKey release];
    [super dealloc];
}

- (void)cleanupOpenSSL
{
	EVP_cleanup();
    ERR_free_strings();
}


RSA *get_RSA_from_str(char *str, int cert_type, char *passphrase)
{
	EVP_PKEY   *pub;
	BIO      *mbio;
	
	mbio = BIO_new_mem_buf((void *)str, strlen(str));
	if (cert_type == PUBLIC_CERTIFICATE) {
		X509 *x509 = PEM_read_bio_X509(mbio, NULL, NULL, NULL);
		if (x509 == NULL) {
			printf("Error reading x509 bio\n");
			ERR_print_errors_fp(stderr);
			return NULL;
		}
		pub = X509_get_pubkey(x509);
		X509_free(x509);
	}
	else if (cert_type == PRIVATE_KEY)
		pub = PEM_read_bio_PrivateKey(mbio, NULL, NULL, passphrase);
	else if (cert_type == PUBLIC_KEY)
		pub = PEM_read_bio_PUBKEY(mbio, NULL, NULL, passphrase);
	
	BIO_reset(mbio);
	BIO_free(mbio);
	if (pub == NULL) {
		printf("Error reading the %d key \n", cert_type);
		ERR_print_errors_fp (stderr);
		return NULL;
	}
	RSA *tmp = EVP_PKEY_get1_RSA(pub);
	EVP_PKEY_free(pub);
	return (tmp);
}

int public_encrypt(RSA *pkey, unsigned char *data_source, int length, ngx_str_t *output)
{
	int size = RSA_size(pkey);
	int block_size = size - MAN_OAEP_PADDING;
	int blocks = length / block_size;
	int rest = length % block_size;
	int i;
	int el;
	
	output->data = malloc((blocks + ((rest == 0) ? 0 : 1)) * size + 1);
	if (output->data == NULL)
		return 0;
	for (i = 0, output->len = 0; i < blocks || (i == blocks && rest != 0); i++) {
		if (blocks == i)
			el = RSA_public_encrypt(rest, data_source + i * block_size, 
									output->data + i * size, pkey, 
									RSA_PKCS1_OAEP_PADDING);
		else
			el = RSA_public_encrypt(block_size, data_source + i * block_size, 
									output->data + i * size, pkey, 
									RSA_PKCS1_OAEP_PADDING);
		if (el < 1)
			return 0;
		output->len += el;
	}
	return 1;
}

int private_decrypt(RSA *pkey, unsigned char *data_source, int length,
					ngx_str_t *output)
{
	int size = RSA_size(pkey);
	int block_size = size - MAN_OAEP_PADDING;
	int blocks = length / size;
	int i;
	int el;
	
	output->data = malloc(blocks * block_size + 1);
	if (output->data == NULL)
		return 0;
	
	memset(output->data, 0, blocks * block_size);
	for (i = 0, output->len = 0; i < blocks; i++) {
		el = RSA_private_decrypt(size, data_source + i * size, output->data +
								 output->len, pkey, RSA_PKCS1_OAEP_PADDING);
		if (el < 1)
			return 0;
		output->len += el;
	}
	return 1;
}

- (NSString*)encrypt_string:(NSString*)blankText PublicKey:(NSString*)pub
{
 	char       pubkey[2048]; 
	unsigned char cleartext[2560];
	ngx_str_t   out_pub;
	ngx_str_t   data;
	
	strcpy(pubkey, [pub cStringUsingEncoding:NSASCIIStringEncoding]);
	char c = pubkey[strlen(pubkey)-1];
	if(c == '\n')
		c = '\0';
	
	memset(cleartext,0,sizeof(cleartext));
	strcpy((char*)cleartext, [blankText cStringUsingEncoding:NSASCIIStringEncoding]);
	
	RSA *pubk = get_RSA_from_str(pubkey, PUBLIC_KEY, NULL); 
	if (pubk == NULL) {
		return @"";
	}
	
	NSString* b64Encrypted = @"";
	data.data = (u_char *)cleartext;
	data.len = strlen((char *)data.data);
	int result = 0;
	int i = 0;
	for(; i < TRY_ENCRYPT_COUNT; i++){
		result = public_encrypt(pubk, data.data, data.len, &out_pub);
		//printf("1,%s\n", out_pub.data);
		if(result){
			char encode_buf[BUFFSIZE];
			memset(encode_buf,0,sizeof(encode_buf));
			B64_Encode(encode_buf, BUFFSIZE, (const char*)(out_pub.data), strlen((char*)(out_pub.data)));
			
			//[data appendString:[imgData base64EncodedString:0]];
			
			//from my expierence.
			if(strlen(encode_buf) >= 180){
				//strcpy(buffer, encode_buf);
				b64Encrypted = [[NSString alloc] initWithCString:(const char*)encode_buf encoding:NSASCIIStringEncoding];
				break;
			}else{
				printf("encode_buf:%s\n", encode_buf);
			}			
		}
	}
	
	free(out_pub.data);		
	ERR_print_errors_fp(stdout);
	RSA_free(pubk);	        
	
	return b64Encrypted;
	
}

- (NSString*)encrypt_string_old:(NSString*)clear PublicKey:(NSString*)pub{
	
	RSA *myRSA;
    unsigned char cleartext[2560] = { 0 };
    unsigned char encrypted[2560] = { 0 };
    //unsigned char decrypted[2560] = { 0 };
    int resultEncrypt = 0;
 	
    char    pubkey[1024];
	memset(pubkey,0,sizeof(pubkey));
	strcpy(pubkey, [pub cStringUsingEncoding:NSASCIIStringEncoding]);
	char c = pubkey[strlen(pubkey)-1];
	if(c == '\n')
		c = '\0';
	
	strcpy((char*)cleartext, [clear cStringUsingEncoding:NSASCIIStringEncoding]);
	myRSA = get_RSA_from_str(pubkey, PUBLIC_KEY, NULL); 
	//RSA *subk = get_RSA_from_str(privkey, PRIVATE_KEY, NULL);
	if (myRSA == NULL) {
		printf("Error setting key from EVP_PKEY_set1_RSA function\n");
		return @"";
	}
	
	NSString* b64Encrypted = @"";
	int i = 0;
	for(;i < 6; i++){
		resultEncrypt = RSA_public_encrypt (  strlen((char*)cleartext) , cleartext, encrypted, myRSA, RSA_PKCS1_OAEP_PADDING );
		//printf("%d from encrypt.\n", resultEncrypt);
		//printf("%s from encrypt.\n", encrypted);
		if(!resultEncrypt)continue;
		char encode_buf[BUFFSIZE];
		memset(encode_buf,0,sizeof(encode_buf));
		B64_Encode(encode_buf, BUFFSIZE, (const char*)encrypted, 
				   strlen((char*)encrypted));
		//from my expierence.
		if(strlen(encode_buf) >= 180){
			//return [NSString stringWithCString:(const char*)encrypted length:strlen((char*)encrypted)];  
			b64Encrypted = [[NSString alloc] initWithCString:(const char*)encode_buf encoding:NSASCIIStringEncoding];
			break;
		}else{
			printf("encode_buf:%s\n", encode_buf);
		}
	}
    //resultDecrypt = RSA_private_decrypt(  resultEncrypt, encrypted, decrypted, myRSA, RSA_PKCS1_OAEP_PADDING);
    //printf("%d from decrypt: '%s'\n", resultDecrypt, decrypted);
	
    RSA_free ( myRSA );		
	
	return b64Encrypted;
	
}

- (NSString*)encrypt_string2:(NSString*)clear PublicKey:(NSString*)pub{
	char        pubkey[2048]; 
	unsigned char cleartext[2560];
	ngx_str_t   out_pub;
	ngx_str_t   data;
	
	//strcpy(pubkey, [pub cStringUsingEncoding:NSASCIIStringEncoding]);
	const char* temp = [pub cStringUsingEncoding:NSASCIIStringEncoding];
	strncpy(pubkey, temp, strlen(temp) - 1);	
	strcpy((char*)cleartext, [clear cStringUsingEncoding:NSASCIIStringEncoding]);
	
	RSA *pubk = get_RSA_from_str(pubkey, PUBLIC_KEY, NULL); 
	if (pubk == NULL) {
		printf("Error setting key from EVP_PKEY_set1_RSA function\n");
		return @"";
	}
	
	data.data = (u_char *)cleartext;
	data.len = strlen((char *)data.data);
	
	public_encrypt(pubk, data.data, data.len, &out_pub);
	printf("1,%s\n", out_pub.data);		
	//NSString* result =  [NSString stringWithCString:(const char*)out_pub.data length:strlen((char*)out_pub.data)];
	NSString* result = [[NSString alloc] initWithCString:(const char*)out_pub.data encoding:NSASCIIStringEncoding];
	
	free(out_pub.data);
	
	ERR_print_errors_fp(stdout);
	RSA_free(pubk);			
	
	return result;
	
}

- (NSInteger)main_test
{
	
#ifdef STATIC_KEY	
	char        pubkey[] = PUBLIC_KEY_DATA; 		
	//char     pubcert[] = PUBLIC_CERTIFICATE_DATA;
	char     privkey[] = PRIVATE_KEY_DATA;
	ngx_str_t   out_priv;
	ngx_str_t   out_pub;
	ngx_str_t   data;
	
	//RSA *pubk = get_RSA_from_str(pubcert, PUBLIC_CERTIFICATE, NULL);
	RSA *pubk = get_RSA_from_str(pubkey, PUBLIC_KEY, NULL); 
	RSA *subk = get_RSA_from_str(privkey, PRIVATE_KEY, NULL);
	if (pubk == NULL || subk == NULL) {
		printf("Error setting key from EVP_PKEY_set1_RSA function\n");
		exit(0);
	}
	
	data.data = (u_char *)"sevenuc";
	data.len = strlen((char *)data.data);
	
	public_encrypt(pubk, data.data, data.len, &out_pub);
	private_decrypt(subk, out_pub.data, out_pub.len, &out_priv);
	//printf("1,%s\n", out_pub.data);
	//printf("2,%s\n", out_priv.data);
	
	data.data = (u_char *)"other";
	data.len = strlen((char *)data.data);
	public_encrypt(pubk, data.data, data.len, &out_pub);
	private_decrypt(subk, out_pub.data, out_pub.len, &out_priv);
	//printf("3,%s\n", out_pub.data);
	//printf("4,%s\n", out_priv.data);
	
	free(out_priv.data);
	free(out_pub.data);
	
	ERR_print_errors_fp(stdout);
	RSA_free(pubk);
	RSA_free(subk);
	
#else	
	
	RSA *myRSA;
    unsigned char cleartext[2560] = { 0 };
    unsigned char encrypted[2560] = { 0 };
    unsigned char decrypted[2560] = { 0 };
    int resultEncrypt = 0;
    int resultDecrypt = 0;
	
	strcpy((char*)cleartext, "cleartext");
    //myRSA = RSA_generate_key ( 1024, 65537, NULL, NULL );
	
	char        pubkey[] = PUBLIC_KEY_DATA; 		
	myRSA = get_RSA_from_str(pubkey, PUBLIC_KEY, NULL); 
	//RSA *subk = get_RSA_from_str(privkey, PRIVATE_KEY, NULL);
	if (myRSA == NULL) {
		printf("Error setting key from EVP_PKEY_set1_RSA function\n");
		exit(0);
	}
	
    resultEncrypt = RSA_public_encrypt (  strlen((char*)cleartext) , cleartext, encrypted, myRSA, RSA_PKCS1_OAEP_PADDING );
    //printf("%d from encrypt.\n", resultEncrypt);
	printf("%s from encrypt.\n", encrypted);
	
    resultDecrypt = RSA_private_decrypt(  resultEncrypt, encrypted, decrypted, myRSA, RSA_PKCS1_OAEP_PADDING);
    printf("%d from decrypt: '%s'\n", resultDecrypt, decrypted);
    RSA_free ( myRSA );
	
#endif
	
	return 0;
}

@end

