import haxe.ds.StringMap;

var strums:Array<StrumNote> = [];

var manager:StringMap<FlxTween> = new StringMap<FlxTween>();

function noteTween(tag:String, index:Int, vars:Any, ?beats:Int, ?opts:Any)
{
    var note = strums[index];

    if (manager.exists(tag))
        manager.get(tag).cancel();

    fixY(vars);

    beats ??= 1;

    manager.set(FlxTween.tween(note, vars, beats * 60 / Conductor.bpm, opts));
}

function noteProps(index:Int, vars:Any)
{
    var note = strums[index];

    fixY(vars);

    setMultiProperty(note, vars);
}

function fixY(props)
{
    if (props != null)
        if (Reflect.field(props, 'y') != null && ClientPrefs.data.downScroll)
            props.y = FlxG.height - props.y - note.height;
}

function postCreate()
{
    for (i in 0...4)
    {
        game.strumLineNotes.members[i].alpha = 0.25;
        game.strumLineNotes.members[i].scrollFactor.set(1, 1);
    }

    for (note in game.unspawnNotes)
        if (!note.mustPress)
            note.scrollFactor.set(1, 1);

    for (note in game.notes)
        note.scrollFactor.set(1, 1);

    strums = [for (i in 4...8) game.strumLineNotes.members[i]];

    for (script in game.hScripts)
    {
        script.set('strums', strums);

        script.set('noteTween', noteTween);

        script.set('noteProps', noteProps);
    }
}

function setMultiProperty(obj:Dynamic, props:Dynamic)
{
    var fields = Reflect.fields(props);

    for (key in fields)
    {
        var value:Dynamic = Reflect.field(props, key);

        if (Reflect.fields(value).length > 0)
        {
            var subObj = Reflect.field(obj, key) ?? Reflect.getProperty(obj, key);

            setMultiProperty(subObj, value);
        } else {
            Reflect.setProperty(obj, key, value);
        }
    }
}