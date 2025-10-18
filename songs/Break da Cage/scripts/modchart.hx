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
}