/**
 *	LeapUDK
 *
 *	Creation date: 19/02/2013 18:42
 *	Copyright 2013, Hugo Lamarche (lamarchehugo@gmail.com)
 */

class LeapUDK extends Object
	DLLBind(LeapUDK);

// Init the Leap Motion Controller, must be call once
dllimport final function initLeapMotion();

// Uninit the Leap Motion Controller, must be call once
dllimport final function uninitLeapMotion();

// Tell you if the Leap Motion Controller is currently connected
dllimport final function bool isLeapMotionConnected();

// Update the current frame and give you the new frame ID, compare the frame id with the previous to know if there is a new frame
dllimport final function updateFrame(out int newFrameId);

// Get the number of hand in the frame
dllimport final function int getNbHands();

// Allow to get information of the hand of index iHand
dllimport final function getHandInfo(int iHand, out int handId, out vector palmPosition, out vector palmVelocity, out rotator palmRotation);

// Get the number of finger for a handId
dllimport final function int getNbFingers(int handId);

// Allow to get information for finger of index iFinger
dllimport final function getFingerInfo(int handId, int iFinger, out int fingerId, out vector tipPosition, out rotator tipRotation);