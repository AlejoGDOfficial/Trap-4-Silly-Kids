import flixel.math.FlxRect;

for (i in 0...3)
    Paths.image('ui/noLoop' + i);

var hud:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
hud.cameras = [game.camHUD];

function gimmeSprite(str:String):FlxSprite
    return new FlxSprite().loadGraphic(Paths.image('ui/' + str));

var frame:FlxSprite = gimmeSprite('frame');
frame.y = FlxG.height - frame.height;
hud.add(frame);

var shot:FlxSprite = gimmeSprite('shot');
hud.add(shot);
shot.x = FlxG.width / 2 - shot.width / 2;

shot.y = FlxG.height - shot.height - 20;

var barFill:FlxSprite = gimmeSprite('barFill');
barFill.setPosition(876, frame.y + 235);
hud.add(barFill);
barFill.alpha = 0.5;

for (i in 0...3)
{
    var obj:FlxSprite = gimmeSprite('loop' + i);
    hud.add(obj);

    obj.setPosition(FlxG.width - [135, 30, 10][i] - obj.width, FlxG.height - obj.height - 10);
}

function postCreate()
{
    remove(game.uiGroup);

    goodNoteHit();

    add(hud);

    game.camGame.snapToTarget();
}

function goodNoteHit()
{
    barFill.clipRect = new FlxRect(0, 0, barFill.width * (game.health / 2), barFill.height);
}