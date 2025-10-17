import flixel.math.FlxRect;

using StringTools;

for (i in 0...3)
    Paths.image('ui/noLoop' + i);

var hud:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
hud.cameras = [game.camOther];

function gimmeSprite(str:String):FlxSprite
    return new FlxSprite().loadGraphic(Paths.image('ui/' + str));

var frame:FlxSprite = gimmeSprite('frame');
frame.y = FlxG.height - frame.height;
hud.add(frame);

var shot:FlxSprite = gimmeSprite('shot');
hud.add(shot);
shot.x = FlxG.width / 2 - shot.width / 2;
shot.alpha = 0.2;

shot.y = FlxG.height - shot.height - 20;

for (i in 0...3)
{
    var obj:FlxSprite = gimmeSprite(([5, 10, 15][i] <= (CoolUtil.save.custom.data.lives ?? 15) ? 'loop' : 'noLoop') + i);
    hud.add(obj);

    obj.setPosition(FlxG.width - [135, 30, 10][i] - obj.width, FlxG.height - obj.height - 10);
}

function postCreate()
{
    remove(game.uiGroup);

    add(hud);

    for (obj in hud)
        obj.antialiasing = ClientPrefs.data.antialiasing;

    game.camGame.snapToTarget();
}

var wantsDebug:Bool = true;

var debugQuoteList:Array<String> = Paths.getContent('quotes.txt').split('\n');

var debugQuotePhrase:Array<String> = debugQuoteList[FlxG.random.int(0, debugQuoteList.length - 1)].split('::');

function onUpdate(elapsed:Float)
{
    if (FlxG.keys.justPressed.SPACE)
    {
        shot.alpha = 1;

        FlxTween.cancelTweensOf(shot);

        FlxTween.tween(shot, {alpha: 0.2}, 0.5, {ease: FlxEase.cubeOut});
    }

    if (Controls.ENGINE_CHART && wantsDebug)
    {
        wantsDebug = false;

        FlxTween.tween(game, {playbackRate: 5}, 1, {
            ease: FlxEase.cubeIn,
            onComplete: (_) -> {
                FlxG.sound.music.pause();

                game.vocals?.pause();

                game.health = 0;

                FlxG.fullscreen = false;

                WindowsAPI.showMessageBox(debugQuotePhrase[0], debugQuotePhrase[1], 0x00000030);
            }
        });
    }

    game.camOther.zoom = CoolUtil.fpsLerp(game.camOther.zoom, 1, 0.2);
}

final missesLimit:Int = CoolUtil.save.custom.data.lives ?? 15;

var missesCounter:Int = missesLimit;

var text:FlxText = new FlxText(0, 0, 0, '', 40);
hud.add(text);
text.font = Paths.font('vcr.ttf');
text.text = (missesLimit - missesCounter) + '/' + missesLimit;
text.x = 945 - text.width / 2;
text.y = 690 - text.height / 2;

var score:FlxText = new FlxText(0, 0, 0, '0000000', 40);
hud.add(score);
score.font = Paths.font('vcr.ttf');
score.x = 160 - score.width / 2;
score.y = 667.5 - score.height / 2;

function noteMiss(note:Note)
{
    missesCounter--;

    text.text = (missesLimit - missesCounter) + '/' + missesLimit;
    text.x = 945 - text.width / 2;

    if (missesCounter <= 0)
    {
        CoolUtil.save.custom.data.lives = switch(missesLimit)
        {
            case 15:
                10;
            case 10:
                5;
            case 5:
                1;
            case 1:
                15;
        };

        game.shouldClearMemory = false;

        game.health = 0;
    }
}

function onRecalculateRating()
{
    score.text = Std.string(game.songScore).lpad('0', 7);
    score.x = 160 - score.width / 2;
}

game.camZooming = false;

game.skipCountdown = true;