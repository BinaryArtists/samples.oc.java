//
//  Library.cpp
//  ccworld
//
//  Created by Henry Yu on 10-11-07.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <assert.h>

#include "Library.h"

OSystem *osystem = NULL;

OSystem::OSystem(){	
	_RenderWindow = (RenderWindow *)malloc(sizeof(RenderWindow));		
}

OSystem::~OSystem() {	
	free(_RenderWindow);
}

void OSystem::Exit(){
	if(osystem){
		delete osystem;
		osystem = NULL;
	}
}

OSystem *OSystem_Init() {
	return new OSystem();
}

OSystem* OSystem::OSystem_Init() {
	if(!osystem)
		osystem = new OSystem();
	return NULL;
}

void OSystem::StartEngine(const char* str){	
	printf("%s\n",str);	
}

int  OSystem::GetChannelList(char *data){
	if(data)
		strcpy(data,"String From C++");	
	if(_RenderWindow->Render)
		_RenderWindow->Render();		
	return 1;
}

