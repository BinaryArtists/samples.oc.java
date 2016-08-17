package com.mindtherobot.samples.asyncmvc.controller;

public interface ControllerProtocol {
	// messages const value about Views
	int V_REQUEST_QUIT = 101; // empty
	int V_REQUEST_UPDATE = 102; // empty
	int V_REQUEST_DATA = 103; // empty
	
	// messages const value about Controller
	int C_QUIT = 201; // empty
	int C_UPDATE_STARTED = 202; // empty
	int C_UPDATE_FINISHED = 203; // empty
	int C_DATA = 204; // obj = (ModelData) data
}
