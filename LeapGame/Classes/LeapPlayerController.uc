class LeapPlayerController extends PlayerController;

var LeapUDK LeapUDK;
var Vector MyLocation;
var LeapMotionActor leapMotionActor;
//var LeapActor leapActor;
var Vector StartVector;
var LeapMoviePlayer leapMoviePlayer;

//boolean, um zu ermitteln, ob man sich per Geste nach vorn bewegen soll oder nicht
var bool moveForward;

//für links/rechts-Rotation
var bool rotateLeft;
var bool rotateRight;

//zur Anpassung der links/rechts/vorne/hinten-Bewegung
var float RadianToDegree;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    
    LeapUDK = new class'LeapUDK';
    LeapUDK.initLeapMotion();
    
    leapMoviePlayer = new class'LeapMoviePlayer';
    
    leapMotionActor = Spawn(class'LeapMotionActor');  
    //leapActor = Spawn(class 'LeapActor');
    
    leapMotionActor.setLocation(vect(1115.77,-1351.05,2));
    //leapActor.setLocation(vect(1215.77,-1351.05,2));
    
    leapMoviePlayer.MyFunction("selectClicked");
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
            
            //Bei einem Finger: Rotation nach links
            //Bei zwei Fingern: Rotation nach rechts
            if(rotateLeft)
            {
                OldRotation.Yaw -= 400;
            } 
            else if (rotateRight)
            {
                OldRotation.Yaw += 400;   
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

//zur Anpassung der z Koordinate, die ansonten zu groß wird
local vector handPosition;
local vector newPosition;
local rotator currentRotation;
local float currentRotationDegree;

local float offset;


super.PlayerTick(DeltaTime);

    DeltaTime = 5;
    
    MyLocation = Pawn.Location;
    
    leapMotionActor.setLocation(MyLocation - vect(0,0,80));
    //leapActor.setLocation(MyLocation + vect(100,0,-80));
    
    currentRotation = (Pawn.Rotation * UnrRotToDeg)*-1;
    currentRotation.Yaw = currentRotation.Yaw % 360;
    //ClientMessage("aktueller Winkel (Degree):"$ currentRotation.Yaw $ " Grad.");
    //ClientMessage("aktueller Cos:"$ cos(currentRotation.Yaw * 0.01745329252));
    //ClientMessage("aktueller Sin:"$ sin(currentRotation.Yaw * 0.01745329252));
    
    //leapMoviePlayer.MyFunction("selectClicked");
    
    //leapMotionActor.setRotation(Pawn.Rotation);
    //leapActor.setRotation(Pawn.Rotation);

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
        currentRotationDegree = currentRotation.Yaw * 0.01745329252;
        handPosition.x =  ((palmPosition.x + offset)*cos(currentRotationDegree)) + (sin(currentRotationDegree) * palmPosition.y);
        //handPosition.x = palmPosition.x;
        handPosition.y = (palmPosition.y*cos(currentRotationDegree)) - (sin(currentRotationDegree) * (palmPosition.x + offset));
        //handPosition.y = palmPosition.y;
        
       //Anpassung der z-Koordinaten, ansonsten zu großer Ausschwung nach oben/unten
        handPosition.z = palmPosition.z-150;
        
        newPosition = MyLocation + handPosition;
        
        //if(iHand == 0) {
             leapMotionActor.setLocation( newPosition );
         //}
        
         //if(iHand == 1) {
             //leapActor.setLocation( newPosition );       
         //}
   }
    
    nbFingers = LeapUDK.getNbFingers(handId);
    
    if (nbFingers == 1 )
    {
        rotateLeft = true;
        rotateRight = false;
    }
    else if(nbFingers == 2)
    {
        //CallMyActionScriptFunc("selectClicked");
        rotateRight = true;
        rotateLeft = false;
    }
    else {
        rotateRight = false;
        rotateLeft = false;  
    }
    
    //Wenn keine Finger erkannt werden, also eine Faust gemacht wird, bewegt man sich nach vorne
    if(nbFingers == 0 && nbHands > 0)
        {
            moveForward = true; 
        } 
        else
        {
            moveForward = false;
        }
        
    for (iFinger = 0; iFinger < nbFingers; iFinger++)
        {
           // Get the fingers informations
           LeapUDK.getFingerInfo(handId, iFinger, fingerId, tipPosition, tipRotation);
        
           // Use here information abouts fingers to do something
           
       }
    }
}

defaultproperties
{
    CameraClass=class 'LeapGame.LeapCamera'
}