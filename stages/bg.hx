function gimmeSprite(spr:FlxSprite, ?x:Float, ?y:Float, ?sX:Float, ?sY:Float):FlxSprite
{
    var spr = new FlxSprite(x, y).loadGraphic(Paths.image('bg/' + spr));
    spr.scrollFactor.set(sX ?? 1, sY ?? 1);

    return spr;
}

var sky = gimmeSprite('sky', -1000, -500, 0.1, 0.1);

var stars = gimmeSprite('stars', -1000, -500, 0.1, 0.1);

var clouds = gimmeSprite('clouds', -1500, -500, 0.2, 0.5);

var mountain0 = gimmeSprite('mountain0', -1000, 150, 0.3, 0.4);
var mountain1 = gimmeSprite('mountain1', -1000, 200, 0.4, 0.5);
var mountain2 = gimmeSprite('mountain2', -1000, 500, 0.5, 0.6);

var build0 = gimmeSprite('build0', -650, -200, 0.6, 0.7);
var build1 = gimmeSprite('build1', 1800, -100, 0.8, 0.9);

var street = gimmeSprite('street', -1000, -450);

var wall = gimmeSprite('wall', -1000, 900, 1.3, 1.1);

function postCreate()
{
    for (behGif in [sky, stars, mountain0, mountain1, mountain2, build0, clouds, build1, street])
        addBehindGF(behGif);

    for (froGif in [wall])
        add(froGif);
}