class LeapPlayerController extends PlayerController;

var LeapUDK LeapUDK;
var Vector MyLocation;
var LeapMotionActor leapMotionActor;
var LeapFinger leapFinger1;
var LeapFinger leapFinger2;
var LeapFinger leapFinger3;
var LeapFinger leapFinger4;
var LeapFinger leapFinger5;

var Vector StartVector;
var LeapMoviePlayer leapMoviePlayer;

//boolean, um zu ermitteln, ob man sich per Geste nach vorn bewegen soll oder nicht
var bool moveForward;
var bool moveBackward;

//für links/rechts-Rotation
var bool rotateLeft;
var bool rotateRight;

var bool moveLeft;
var bool moveRight;

//zur Anpassung der links/rechts/vorne/hinten-Bewegung
var float RadianToDegree;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    
    LeapUDK = new class'LeapUDK';
    LeapUDK.initLeapMotion();
    
    leapMoviePlayer = new class'LeapMoviePlayer';
    
    leapMotionActor = Spawn(class'LeapMotionActor');  
    leapFinger1 = Spawn(class 'LeapFinger');
    leapFinger2 = Spawn(class 'LeapFinger');
    leapFinger3 = Spawn(class 'LeapFinger');
    leapFinger4 = Spawn(class 'LeapFinger');
    leapFinger5 = Spawn(class 'LeapFinger');
    
    //leapMoviePlayer.MyFunction("selectClicked");
}

// Called at RestartPlayer by GameType
public function rSetCameraMode(name cameraSetting){
    SetCameraMode(cameraSetting);
}

simulated event PreBeginPlay()
{
    super.PreBeginPlay();
}

simulated function preExit() {
    LeapUDK.uninitLeapMotion();   
}

state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;

    function PlayerMove( float DeltaTime )
    {
        local vector            X,Y,Z, NewAccel;
        local eDoubleClickDir   DoubleClickMove;
        local rotator           OldRotation;
        local bool              bSaveJump;

        if( Pawn == None )
        {
            GotoState('Dead');
        }
        else
        {
            GetAxes(Pawn.Rotation,X,Y,Z);

            // Update acceleration.
            if(moveForward)
            {
                NewAccel = 1.0*X;
            }
            else if(moveBackward)
            {
                NewAccel = -1.0*X;    
            }
            
            else if(moveLeft) {
                NewAccel = -1.0*Y;       
            }
            else if(moveRight)
            {
                NewAccel = 1.0*Y;   
            }
            else {
                NewAccel = PlayerInput.aForward*X + PlayerInput.aStrafe*Y;             
            }
            
            NewAccel.Z  = 0;
            NewAccel = Pawn.AccelRate * Normal(NewAccel);

            if (IsLocalPlayerController())
            {
                AdjustPlayerWalkingMoveAccel(NewAccel);
            }

            DoubleClickMove = PlayerInput.CheckForDoubleClickMove( DeltaTime/WorldInfo.TimeDilation );

            // Update rotation.
            OldRotation = Rotation;
            
            if(rotateLeft)
            {
                OldRotation.Yaw -= 200;
            } 
            else if (rotateRight)
            {
                OldRotation.Yaw += 200;   
            }
            SetRotation(OldRotation);
            
            UpdateRotation( DeltaTime );
            bDoubleJump = false;

            if( bPressedJump && Pawn.CannotJumpNow() )
            {
                bSaveJump = true;
                bPressedJump = false;
            }
            else
            {
                bSaveJump = false;
            }

            if( Role < ROLE_Authority ) // then save this move and replicate it
            {
                ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
            }
            else
            {
                ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
            }
            bPressedJump = bSaveJump;
        }
    }
}

//zur Umwandlung der LeapMotion-Koordinaten in Lokale UDK-Koordinaten
function vector WorldToLocalVector( float X, float Y, float Z, float offset, float Degree )
{
    local vector newVector;
    newVector.x =  ((X + offset)*cos(Degree)) + (sin(Degree) * Y);
    newVector.y = (Y*cos(Degree)) - (sin(Degree) * (X + offset));
    newVector.z = Z - 150;
    
    return newVector;
}

simulated event PlayerTick( float DeltaTime )
{
local int frameId;
local int nbHands;
local int nbFingers;
local int iHand;
local int iFinger;
local int handId;
local int fingerId;
local vector palmPosition;
local vector palmVelocity;
local rotator palmRotation;
local vector tipPosition;
local rotator tipRotation;

local vector newPosition;
local rotator currentRotation;
local float currentRotationDegree;

local float offset;


super.PlayerTick(DeltaTime);

    DeltaTime = 5;
    
    MyLocation = Pawn.Location;
    
    currentRotation = (Pawn.Rotation * UnrRotToDeg)*-1;
    currentRotation.Yaw = currentRotation.Yaw % 360;
    
    leapMotionActor.setRotation(Pawn.Rotation);
    leapFinger1.setRotation(Pawn.Rotation);
    leapFinger2.setRotation(Pawn.Rotation);
    leapFinger3.setRotation(Pawn.Rotation);
    leapFinger4.setRotation(Pawn.Rotation);
    leapFinger5.setRotation(Pawn.Rotation);

// Be sure that the leap motion is present and ready
if (LeapUDK.isLeapMotionConnected())
{
    
    // Update the currentframe and get the new frame id, idealy use this idealy to know if the frame change from the previous call
    LeapUDK.updateFrame(frameId);
    
    nbHands = LeapUDK.getNbHands();
        
    for (iHand = 0; iHand < nbHands; iHand++)
    {
        // Get the hands informations
        LeapUDK.getHandInfo(iHand, handId, palmPosition, palmVelocity, palmRotation);
        
        offset = 400.0;

        // Use here information abouts hands to do something
        
        
        //die x,y-Koordinaten des LeapMotion-Controllers müssen an das Koordinatensystem von UDK in Abhängigkeit vom Winkel des Spielers neu berechnet werden.
        currentRotationDegree = currentRotation.Yaw * RadianToDegree;
       
       newPosition = MyLocation + WorldToLocalVector( palmPosition.x, palmPosition.y, palmPosition.z, offset, currentRotationDegree );
        
       leapMotionActor.setLocation( newPosition );
       ClientMessage("New Position: " $ palmPosition);
        
    }
    
    nbFingers = LeapUDK.getNbFingers(handId);
    
    if ( palmPosition.y < -180 && nbFingers > 0)
    {
        rotateLeft = true;
        rotateRight = false;
    }
    else if(palmPosition.y > 180  && nbFingers > 0)
    {
        rotateRight = true;
        rotateLeft = false;
    }
    else {
        rotateRight = false;
        rotateLeft = false;  
    }
    
    //Wenn keine Finger erkannt werden, also eine Faust gemacht wird und diese sich weiter vorne/hinten befindet, bewegt man sich nach vorne/hinten
    if(nbFingers == 0) {
    
        if(palmPosition.x > 80 )
        {
            moveForward = true;
            moveBackward = false; 
        } 
        else if( palmPosition.x < -90 )
        {
            moveBackward = true;
            moveForward = false;
        }
        else
        {
            moveForward = false;
            moveBackward = false;  
        }
        
        if ( palmPosition.y < -120 )
        {
            moveLeft = true;
            moveRight = false;
        }
        else if(palmPosition.y > 120 )
        {
            moveRight = true;
            moveLeft = false;
        }
        else {
            moveRight = false;
            moveLeft = false;  
        }
    
    }
    else {
        moveForward = false;
        moveBackward = false; 
        moveRight = false;
        moveLeft = false;
    }
        
        
    for (iFinger = 0; iFinger < nbFingers; iFinger++)
        {
           // Get the fingers informations
           LeapUDK.getFingerInfo(handId, iFinger, fingerId, tipPosition, tipRotation);
           
           // Use here information abouts fingers to do something
           
           if (iFinger == 0)
           {
                leapFinger1.setLocation( MyLocation + WorldToLocalVector( tipPosition.x, tipPosition.y, tipPosition.z, offset, currentRotationDegree ));
           } 
            
            if(iFinger == 1)
            {
              leapFinger2.setLocation( MyLocation + WorldToLocalVector( tipPosition.x, tipPosition.y, tipPosition.z, offset, currentRotationDegree )); 
            } 
            
            if(iFinger == 2)
            {
               leapFinger3.setLocation( MyLocation + WorldToLocalVector( tipPosition.x, tipPosition.y, tipPosition.z, offset, currentRotationDegree ));  
            } 
            
            if(iFinger == 3)
            {
                leapFinger4.setLocation( MyLocation + WorldToLocalVector( tipPosition.x, tipPosition.y, tipPosition.z, offset, currentRotationDegree )); 
            }
            
            if(iFinger == 4)
            {
                leapFinger5.setLocation( MyLocation + WorldToLocalVector( tipPosition.x, tipPosition.y, tipPosition.z, offset, currentRotationDegree )); 
            } 
        }
    }
}

defaultproperties
{
    CameraClass=class 'LeapGame.LeapCamera'
    RadianToDegree = 0.01745329252
}