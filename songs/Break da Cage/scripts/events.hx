game.cameraSpeed = 2;

var beatFunc:Int -> Void = (curBeat) -> {
    if (curBeat % 4 == 0)
    {
        game.camGame.zoom += 0.0125;
        game.camHUD.zoom += 0.05;
        game.camOther.zoom += 0.0075;
    }
}

function onBeatHit(curBeat:Int)
{
    if (beatFunc != null)
        beatFunc(curBeat);
}

function onUpdate(elapsed:Float)
{
    final factor:Float = 0.05 * game.cameraSpeed * 2;

    game.camGame.zoom = CoolUtil.fpsLerp(game.camGame.zoom, game.defaultCamZoom, factor);
    game.camHUD.zoom = CoolUtil.fpsLerp(game.camHUD.zoom, 0.95, factor);
    game.camOther.zoom = CoolUtil.fpsLerp(game.camOther.zoom, 1, factor);
}