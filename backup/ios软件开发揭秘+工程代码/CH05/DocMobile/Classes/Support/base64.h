/*
* $Id: base64.h 2009-09-3 10:25:48Z henry yu $
*  interface for Gateway and RBAC
*/

#ifndef BASE64_DECODE_H
#define BASE64_DECODE_H

//#include <stdbool.h>
#include <ctype.h>
#include <stdio.h>
 
bool B64_Decode(char* dest, int* dest_size, const char* src, int src_size);
int B64_Encode(char* dest, int dest_size, const char* src, int src_size);

#endif // BASE_64_H
