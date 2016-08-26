//
//  common.h
//  ccworld
//
//  Created by Henry Yu on 10-11-07.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#ifndef _COMMON__H
#define _COMMON__H

// We need this to be able to call functions from/in Objective-C.
#ifdef  __cplusplus
extern "C" {
#endif

void cc_main(int argc, char *argv[]);
void startEngine();


#ifdef __cplusplus
}
#endif

#endif /*_COMMON__H*/
