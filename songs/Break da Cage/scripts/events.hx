game.cameraSpeed = 0.5;

var beatFunc:Int -> Void = null;

var updateFunc:Float -> Void = null;

var bopModulo:Int = 4;

var startTime:Float = CoolVars.data.developerMode ? 555 * 60 / Conductor.bpm * 1000 : (CoolUtil.save.custom.data.initTime ?? 0) * 1000;

function postCreate()
{
    game.comboGroup.scrollFactor.set(0.25, 0.25);

    game.comboGroup.alpha = 0.25;

    if (startTime > 0)
    {
        game.cameraSpeed = 2;

        return;
    }

    game.camHUD.alpha = 0;
    game.camOther.alpha = 0;

    for (char in [game.boyfriend, game.dad])
        char.color = FlxColor.BLACK;

    stage.members.backdrop.color = FlxColor.BLACK;
    stage.members.backdrop.alpha = 0.75;
    stage.members.wall.color = FlxColor.GRAY;
}

var zoomMult:Float = 1;

var camZoom(default, set):Float = 0.5;

function set_camZoom(value:Float):Float
{
    camZoom = value;

    setCameraZoom();

    return camZoom;
}

function onBeatHit(curBeat:Int)
{
    switch (curBeat)
    {
        case 200, 478, 622:
            CoolUtil.save.custom.data.initTime = curBeat * 60 / Conductor.bpm;
        case 266, 550, 686:
            CoolUtil.save.custom.data.initTime = null;
    }

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
        case 81:
            bopModulo = 0;

            game.defaultCamZoom = mustHitSection ? camZoom * 1.5 : camZoom;
    
            FlxTween.tween(game.camGame, {angle: 5}, 60 / Conductor.bpm, {ease: FlxEase.cubeOut});
        case 83:
            bopModulo = 1;
        case 84:
            FlxTween.tween(game.camGame, {angle: 0}, 60 / Conductor.bpm, {ease: FlxEase.cubeOut});
        case 104:
            bopModulo = 0;

            camZoom = 0.8;

            stage.members.backdrop.color = FlxColor.BLACK;
            
            FlxTween.tween(stage.members.backdrop, {alpha: 0.5}, 30 / Conductor.bpm);
        case 107:
            zoomMult = 5;

            camZoom = 0.6;
            
            bopModulo = 1;
            
            FlxTween.tween(stage.members.backdrop, {alpha: 0}, 30 / Conductor.bpm);
        case 108:
            zoomMult = 1;

            camZoom = 0.5;
        case 136:
            bopModulo = 2;

            stage.members.backdrop.color = FlxColor.fromRGB(10, 0, 0);
            
            FlxTween.tween(stage.members.backdrop, {alpha: 0.75}, 30 / Conductor.bpm);

            beatFunc = (curBeat) -> {
                if (curBeat % 4 == 0)
                    camZoom = curBeat % 8 == 0 ? 0.6 : 0.5;
            };
        case 168:
            bopModulo = 1;
        case 200:
            bopModulo = 4;
            
            beatFunc = null;
        case 202:
            camZoom = 0.5;
        case 204:
            bopModulo = 1;
            
            zoomMult = 2;

            FlxTween.tween(stage.members.backdrop, {alpha: 0}, 30 / Conductor.bpm);
        case 251:
            zoomMult = -1;

            game.cameraSpeed = 1;
            
            stage.members.backdrop.color = FlxColor.BLACK;

            camZoom = 0.7;
            
            FlxTween.tween(stage.members.backdrop, {alpha: 0.75}, 60 / Conductor.bpm);
        case 260:
            camZoom = 0.6;
            
            FlxTween.tween(stage.members.backdrop, {alpha: 0.5}, 60 / Conductor.bpm);
        case 268:
            FlxTween.tween(stage.members.backdrop, {alpha: 0}, 30 / Conductor.bpm);

            beatFunc = (curBeat) -> {
                if (curBeat % 4 == 0)
                {
                    bopModulo = curBeat % 8 == 0 ? 2 : 1;
            
                    zoomMult = curBeat % 8 == 0 ? 2.5 : 5;

                    camZoom = curBeat % 8 == 0 ? 0.5 : 0.45;

                    game.cameraSpeed = curBeat % 8 == 0 ? 2 : 2.25;
                }
            };
        case 332:
            beatFunc = null;

            game.cameraSpeed = 1;
        case 336:
            bopModulo = 1;

            camZoom = 0.5;

            zoomMult = 3;

            game.cameraSpeed = 2;
        case 368:
            bopModulo = 1;

            camZoom = 0.45;

            zoomMult = 4;

            game.cameraSpeed = 2.5;

            beatFunc = (curBeat) -> {
                FlxTween.cancelTweensOf(game.camGame);
                FlxTween.cancelTweensOf(game.camHUD);

                FlxTween.tween(game.camGame, {angle: curBeat % 2 == 0 ? -2 : 2}, 60 / Conductor.bpm, {ease: FlxEase.cubeOut});
                FlxTween.tween(game.camHUD, {angle: curBeat % 2 == 0 ? -1 : 1}, 60 / Conductor.bpm, {ease: FlxEase.cubeOut});
            };
        case 391:
            bopModulo = 1;

            zoomMult = 0.5;

            beatFunc = (curBeat) -> {
                zoomMult += 1;
            };

            for (cam in [game.camGame, game.camHUD])
            {
                FlxTween.cancelTweensOf(cam);
                
                FlxTween.tween(cam, {angle: 0}, 60 / Conductor.bpm, {ease: FlxEase.cubeOut});
            }
            
            stage.members.backdrop.color = FlxColor.BLACK;
            
            FlxTween.tween(stage.members.backdrop, {alpha: 0.5}, 30 / Conductor.bpm);
        case 400:
            bopModulo = 1;

            zoomMult = 3;

            camZoom = 0.3;

            beatFunc = null;

            var curTime:Float = 0;

            updateFunc = (elapsed) -> {
                curTime += elapsed * 2;

                game.triggerEvent('Camera Follow Pos', Math.sin(curTime) * 100 + 825, Math.sin(curTime * 2) * 50 + 530, Conductor.songPosition);
            }
        case 432:
            camZoom = 0.45;
            
            game.triggerEvent('Camera Follow Pos', null, null, Conductor.songPosition);

            updateFunc = null;
        case 464:
            bopModulo = 0;
            
            camZoom = 0.5;
        case 472:
            camZoom = 0.6;
        case 480:
            camZoom = 0.5;
            
            FlxTween.tween(stage.members.backdrop, {alpha: 0}, 30 / Conductor.bpm);
        case 484:
            bopModulo = 1;

            zoomMult = 4;
        case 500:
            camZoom = 0.55;
        case 532:
            bopModulo = 1;

            zoomMult = -1;

            stage.members.backdrop.color = FlxColor.BLACK;
            
            FlxTween.tween(stage.members.backdrop, {alpha: 0.75}, 30 / Conductor.bpm);
        case 548:
            bopModulo = 0;

            zoomMult = 1;
        case 556:
            bopModulo = 2;

            zoomMult = 0;

            FlxTween.num(0, 5, 64 * 60 / Conductor.bpm, {ease: FlxEase.cubeIn}, (num) -> { zoomMult = num; });

            game.camGame.flash(FlxColor.BLACK, 64 * 60 / Conductor.bpm, null, true);

            var curTime:Float = 0;

            updateFunc = (elapsed) -> {
                curTime += elapsed * zoomMult / 2.5;

                game.triggerEvent('Camera Follow Pos', Math.sin(curTime) * 100 + 1500, Math.sin(curTime * 2) * 50 + 675, Conductor.songPosition);
            }
        case 588:
            bopModulo = 1;
        case 620:
            bopModulo = 0;

            updateFunc = null;
            
            game.triggerEvent('Camera Follow Pos', null, null, Conductor.songPosition);
    }

    if (beatFunc != null)
        beatFunc(curBeat);

    bopCamera(curBeat);
}

function onSectionHit(curSection:Int)
{
    setCameraZoom();
}

function setCameraZoom()
{
    game.defaultCamZoom = mustHitSection ? camZoom * 1.5 : camZoom;
}

function bopCamera(curBeat:Int)
{
    if (bopModulo <= 0)
        return;

    if (curBeat % bopModulo == 0)
    {
        game.camGame.zoom += 0.0125 * zoomMult;
        game.camHUD.zoom += 0.05 * zoomMult;
        game.camOther.zoom += 0.0075 * zoomMult;
    }
}

function onSongStart()
{
    if (FlxG.sound.music.time < startTime && startTime < FlxG.sound.music.length)
    {
        FlxG.sound.music.time = startTime;
        
        game.clearNotesBefore(startTime + 1000);
    }
}

function onEndSong()
{
    FlxG.sound.music.time = 0;
}

function onUpdate(elapsed:Float)
{
    game.camHUD.scroll.y = 10;

    final factor:Float = 0.05 * game.cameraSpeed * 2;

    game.camGame.zoom = CoolUtil.fpsLerp(game.camGame.zoom, game.defaultCamZoom, factor);
    game.camHUD.zoom = CoolUtil.fpsLerp(game.camHUD.zoom, 0.9, factor);
    game.camOther.zoom = CoolUtil.fpsLerp(game.camOther.zoom, 1, factor);

    if (updateFunc != null)
        updateFunc(elapsed);

    game.camHUD.scroll.x = game.camGame.scroll.x - 100;
    game.camHUD.scroll.y = game.camGame.scroll.y - 50;
}