import funkin.states.PlayState;
import funkin.visuals.game.Character;

import flixel.util.FlxColor;
import flixel.sound.FlxSound;
import flixel.FlxObject;

import utils.cool.PlayStateUtil;

var deathStart:FlxSound;

var bfCamera:FlxCamera;

var bf:Character;

var isDead:Bool = (CoolUtil.save.custom.data.lives ?? 15) >= 15;

function onCreate()
{
    Paths.music('gameOverEnd');
    deathStart = new FlxSound().loadEmbedded(Paths.sound(PlayState.isPixelStage ? 'fnf_loss_sfx-pixel' : 'fnf_loss_sfx'));
	FlxG.sound.list.add(deathStart);
    deathStart.play();

    bfCamera = new ALECamera();
    bfCamera.bgColor = FlxColor.BLACK;
    FlxG.cameras.add(bfCamera, false);
    bfCamera.zoom = game.camGame.zoom;
    bfCamera.scroll.x = game.camGame.scroll.x;
    bfCamera.scroll.y = game.camGame.scroll.y;

    bf = new Character(PlayState.instance.boyfriend.x, PlayState.instance.boyfriend.y, PlayState.instance.boyfriend.deadVariant, true);
    add(bf);
    bf.cameras = [bfCamera];
    bf.playAnim('firstDeath');

    bf.animation.finishCallback = (name:String) -> {
		if (name == 'firstDeath')
		{
			bf.playAnim('deathLoop', true);
		}
	};
    
    var camFollow = new FlxObject(0, 0, 1, 1);
    camFollow.setPosition(bf.getGraphicMidpoint().x + bf.cameraPosition[0], bf.getGraphicMidpoint().y + bf.cameraPosition[1]);
    bfCamera.follow(camFollow, null, 0.025);

    if (!isDead)
        FlxTimer.wait(2, () -> {
            reset();
        });
}

var canPress:Bool = true;

function onUpdate()
{
    if (canPress && isDead)
    {
        if (Controls.ACCEPT)
        {
            reset();

            canPress = false;
        }

        if (Controls.BACK)
		{
            CoolVars.skipTransIn = true;

            PlayStateUtil.exitSong();
            
            close();
        }
    }
}

function reset()
{
    deathStart.stop();
    
    FlxG.sound.play(Paths.music(PlayState.isPixelStage ? 'gameOverEnd-pixel' : 'gameOverEnd'));

    bf.playAnim('deathConfirm', true);

    FlxTween.cancelTweensOf(bfCamera);

    PlayState.instance.shouldClearMemory = false;

    FlxTween.tween(bf, {alpha: 0}, isDead ? 2 : 0.5, {ease: FlxEase.quintIn, onComplete: (_) -> { CoolUtil.resetState(); }});

    FlxTween.tween(bf.scale, {x: bf.scale.x - 0.1, y: bf.scale.y - 0.1}, isDead ? 2 : 0.5, {ease: FlxEase.quintIn});
}

var mobileCamera:FlxCamera;

function postCreate()
{
    if (CoolVars.mobileControls && isDead)
    {
        mobileCamera = new FlxCamera();
        mobileCamera.bgColor = FlxColor.TRANSPARENT;
        FlxG.cameras.add(mobileCamera, false);

        var buttonMap:Array<Dynamic> = [
            [1105, 485, ClientPrefs.controls.ui.accept, 'a uppercase'],
            [950, 485, ClientPrefs.controls.ui.back, 'b uppercase']
        ];

        for (button in buttonMap)
        {
            var obj:MobileButton = new MobileButton(button[0], button[1], button[2], button[3]);
            add(obj);
            obj.label.angle = button[4] ?? 0;
            obj.cameras = [mobileCamera];
        }
    }
}

function onDestroy()
{
    if (CoolVars.mobileControls && isDead)
        FlxG.cameras.remove(mobileCamera);

    FlxG.cameras.remove(bfCamera);
}