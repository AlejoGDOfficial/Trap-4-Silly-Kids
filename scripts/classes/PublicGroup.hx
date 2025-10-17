class PublicGroup
{
    public var members:Dynamic;

    public function new(fields:Dynamic)
    {
        members = fields;
    }

    public function forEach(func:Dynamic -> Void)
    {
        for (obj in Reflect.fields(members))
        {
            var obj = Reflect.field(members, obj);
            
            if (obj is FlxTypedGroup)
            {
                for (mem in obj)
                    func(mem);
            } else {
                func(obj);
            }
        }
    }

    public function forSome(names:Array<String>, func:Dynamic -> Void)
    {
        for (obj in Reflect.fields(members))
        {
            if (!names.contains(obj))
                continue;

            var obj = Reflect.field(members, obj);
            
            if (obj is FlxTypedGroup)
            {
                for (mem in obj)
                    func(mem);
            } else {
                func(obj);
            }
        }
    }

    public function forExclude(names:Array<String>, func:Dynamic -> Void)
    {
        for (obj in Reflect.fields(members))
        {
            if (names.contains(obj))
                continue;

            var obj = Reflect.field(members, obj);
            
            if (obj is FlxTypedGroup)
            {
                for (mem in obj)
                    func(mem);
            } else {
                func(obj);
            }
        }
    }
}