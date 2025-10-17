game.cameraSpeed = 0.5;

var beatFunc:Int -> Void = null;

var bopModulo:Int = 4;

var startTime:Float = CoolVars.data.developerMode ? 71 * 60 / Conductor.bpm * 1000 : 0;

function postCreate()
{
    if (startTime > 0)
        return;

    game.camHUD.alpha = 0;
    game.camOther.alpha = 0;

    for (char in [game.boyfriend, game.dad])
        char.color = FlxColor.BLACK;

    stage.members.backdrop.color = FlxColor.BLACK;
    stage.members.backdrop.alpha = 0.75;
    stage.members.wall.color = FlxColor.GRAY;
}

function onBeatHit(curBeat:Int)
{
    switch (curBeat)
    {
        case 32:
            game.cameraSpeed = 1.5;

            for (char in [game.boyfriend, game.dad])
                FlxTween.color(char, 60 / Conductor.bpm, char.color, FlxColor.WHITE, {ease: FlxEase.cubeOut});

            FlxTween.tween(stage.members.backdrop, {alpha: 0}, 240 / Conductor.bpm);
                        
            FlxTween.color(stage.members.wall, 240 / Conductor.bpm, stage.members.wall.color, FlxColor.WHITE, {ease: FlxEase.cubeOut});

            beatFunc = (curBeat) -> {
                if (curBeat % 4 == 0)
                    game.camGame.shake(0.0125, 2 * 60 / Conductor.bpm, null, true, 0x01);
            };
        case 48:
            bopModulo = 2;

            beatFunc = (curBeat) -> {
                if (curBeat % 2 == 0)
                    game.camGame.shake(0.0125, 2 * 60 / Conductor.bpm, null, true, 0x01);
            };
        case 56:
            bopModulo = 1;

            for (char in [game.boyfriend, game.dad])
                FlxTween.color(char, 480 / Conductor.bpm, char.color, FlxColor.BLACK, {ease: FlxEase.cubeOut});

            stage.members.backdrop.color = FlxColor.WHITE;
            
            FlxTween.tween(stage.members.backdrop, {alpha: 1}, 480 / Conductor.bpm);

            FlxTween.tween(stage.members.wall, {alpha: 0}, 480 / Conductor.bpm);
        case 64:
            bopModulo = 0;

            beatFunc = null;
        case 72:
            bopModulo = 1;

            game.cameraSpeed = 2;

            game.camOther.flash(null, 240 / Conductor.bpm, null, true);

            game.camHUD.alpha = 1;
            game.camOther.alpha = 1;

            for (char in [game.boyfriend, game.dad])
                char.color = FlxColor.WHITE;

            stage.members.backdrop.alpha = 0;

            stage.members.wall.alpha = 1;
        case 184:
            bopModulo = 0;
        case 184:
            bopModulo = 1;
    }

    if (beatFunc != null)
        beatFunc(curBeat);

    bopCamera(curBeat);
}

function bopCamera(curBeat:Int)
{
    if (bopModulo <= 0)
        return;

    if (curBeat % bopModulo == 0)
    {
        game.camGame.zoom += 0.0125;
        game.camHUD.zoom += 0.05;
        game.camOther.zoom += 0.0075;
    }
}

function onUpdate(elapsed:Float)
{
    if (FlxG.sound.music.time < startTime)
    {
        FlxG.sound.music.time = startTime;
        
        game.clearNotesBefore(startTime);
    }

    final factor:Float = 0.05 * game.cameraSpeed * 2;

    game.camGame.zoom = CoolUtil.fpsLerp(game.camGame.zoom, game.defaultCamZoom, factor);
    game.camHUD.zoom = CoolUtil.fpsLerp(game.camHUD.zoom, 0.95, factor);
    game.camOther.zoom = CoolUtil.fpsLerp(game.camOther.zoom, 1, factor);
}