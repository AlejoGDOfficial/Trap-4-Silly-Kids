import flixel.addons.display.FlxBackdrop;

import PublicGroup;

var curTime:Float = 0;

var shader:ALERuntimeShader;

var shaderUpdate:Float -> Void;

if (!CoolVars.mobileControls)
{
    switch (CoolUtil.save.custom.data.lives ?? 15)
    {
        case 15:
            shader = CoolUtil.createRuntimeShader('multiple');

            shader.setFloat('blue', 0.8);

            shaderUpdate = (elapsed) -> {
                shader.setFloat('red', Math.sin(curTime) * 0.3 + 1);
                shader.setFloat('green', Math.cos(curTime) * 0.1 + 0.9);
            };
        case 10:
            shader = CoolUtil.createRuntimeShader('multiple');

            shader.setFloat('blue', 0.75);

            shaderUpdate = (elapsed) -> {
                shader.setFloat('factor', Math.sin(curTime) * 0.2 + 1);

                shader.setFloat('red', Math.sin(curTime) * 0.5 + 1.2);
                shader.setFloat('green', Math.cos(curTime) * 0.1 + 0.9);
            };
        case 5:
            shader = CoolUtil.createRuntimeShader('multiple');

            shader.setFloat('blue', 0.6);

            shaderUpdate = (elapsed) -> {
                shader.setFloat('factor', Math.sin(curTime) * 0.2 + 2);

                shader.setFloat('offset', Math.cos(curTime * 1) * 0.005);

                shader.setFloat('red', Math.sin(curTime) * 0.5 + 1.2);
                shader.setFloat('green', Math.cos(curTime) * 0.1 + 0.9);
            };
        case 1:
            shader = CoolUtil.createRuntimeShader('multiple');

            shader.setFloat('blue', 0.5);
            shader.setFloat('green', 0.5);

            shaderUpdate = (elapsed) -> {
                shader.setFloat('factor', Math.sin(curTime) * 0.2 + 2);

                shader.setFloat('offset', Math.cos(curTime * 1) * 0.01);

                shader.setFloat('red', Math.sin(curTime) * 0.5 + 0.8);
            };
    }

    CoolUtil.setCameraShaders(game.camGame, [shader]);
}

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

var street = gimmeSprite('street', -1000, 600);

var fire = new FlxSprite(-1500, -200);
fire.frames = Paths.getSparrowAtlas('bg/fire');
fire.animation.addByPrefix('idle', 'fire', 12);
fire.animation.play('idle');
fire.blend = 0;

var backdrop = new FlxBackdrop().makeGraphic(FlxG.width, FlxG.height);
backdrop.alpha = 0;

var wall = gimmeSprite('wall', -1000, 900, 1.3, 1.1);

function postCreate()
{
    for (behGif in [sky, stars, mountain0, mountain1, mountain2, build0, clouds, build1, street, fire, backdrop])
        addBehindGF(behGif);

    for (froGif in [wall])
        add(froGif);
}

function onUpdate(elapsed:Float)
{
    curTime += elapsed;

    if (!CoolVars.mobileControls)
    {
        shader.setFloat('time', curTime);

        if (shaderUpdate != null)
            shaderUpdate(elapsed);
    }
}

function onSectionHit(curSection:Int)
{
    game.defaultCamZoom = mustHitSection ? 0.8 : 0.5;
}

function onCreate()
{
    for (script in game.hScripts)
    {
        script.set('stage',
            new PublicGroup(
                {
                    sky: sky,
                    stars: stars,
                    clouds: clouds,
                    mountain0: mountain0,
                    mountain1: mountain1,
                    mountain2: mountain2,
                    build0: build0,
                    build1: build1,
                    street: street,
                    fire: fire,
                    backdrop: backdrop,
                    wall: wall
                }
            )
        );
    }
}