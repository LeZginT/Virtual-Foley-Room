class LeapGame extends GameInfo;

var LeapPlayerController currentPlayer;

function RestartPlayer(Controller aPlayer)
{
super.RestartPlayer(aPlayer);
`Log("Player restarted");
currentPlayer = LeapPlayerController(aPlayer);
currentPlayer.rSetCameraMode('FirstPerson');
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
  
}

simulated event PreBeginPlay()
{
    super.PreBeginPlay();
}

event PostLogin( PlayerController NewPlayer )
{
    super.PostLogin(NewPlayer);
    NewPlayer.ClientMessage("Welcome to the game "$NewPlayer.PlayerReplicationInfo.PlayerName);
}

event PlayerController Login(string Portal, string Options, const UniqueNetID UniqueID, out string ErrorMessage)
{
    local PlayerController PC;
    PC = super.Login(Portal, Options, UniqueID, ErrorMessage);
    ChangeName(PC, "LeapMotion", true);
    return PC;
}

defaultproperties
{
    PlayerControllerClass=class'LeapPlayerController'
    DefaultPawnClass=class 'LeapGame.LeapPawn'
    bDelayedStart=false
}