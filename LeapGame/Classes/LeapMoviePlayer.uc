class LeapMoviePlayer extends GFxMoviePlayer;


function bool Start (optional bool startPaused = false)
{
    super.start();   
    Advance(0);
    return true;
}


function callActionScript(string command)
{
    `log(command);
    ActionScriptVoid("leftClicked"); 
}


function flashToUDK(string doThis)
{
    ConsoleCommand(doThis);
}