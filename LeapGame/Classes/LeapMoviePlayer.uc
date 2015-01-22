class LeapMoviePlayer extends GFxMoviePlayer;


function bool Start (optional bool startPaused = false)
{
    super.start();   
    Advance(0);
    return true;
}


function MyFunction(string command)
{
    `log("hi");
    ActionScriptVoid(command); 
}


function flashToUDK(string doThis)
{
    ConsoleCommand(doThis);
}