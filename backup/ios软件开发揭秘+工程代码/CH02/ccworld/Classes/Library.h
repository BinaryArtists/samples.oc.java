//
//  Library.h
//  ccworld
//
//  Created by Henry Yu on 10-11-07.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#ifndef _LIBRARY__H
#define _LIBRARY__H


#ifdef __cplusplus
extern "C" {
#endif

	
typedef void( OEngineRender( void ) );
	
typedef struct
{		
	OEngineRender	*Render;
	void	        *userdata;		
} RenderWindow;	
	
class OSystem{
public:
	OSystem();
	virtual ~OSystem();

public:	
	static OSystem* OSystem_Init();
	void Exit();
	void StartEngine(const char* str);
	int  GetChannelList(char *data);
//private:
	RenderWindow *_RenderWindow;	
};

extern	OSystem *osystem;
	
	
#ifdef __cplusplus
   }
#endif

#endif // _LIBRARY__H
