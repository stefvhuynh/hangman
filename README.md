Hangman
=======

This is a Ruby implementation of the [Hangman](http://en.wikipedia.org/wiki/Hangman_(game)) game. To play, run

```shell
ruby hangman.rb
```

This program also takes two command line arguments. It accepts the values, `human` and `computer`. The first argument will assign the guesser, while the second argument assigns the player who chooses the word. The default has the `human` as the guesser and the `computer` as the word chooser.

```shell
ruby hangman.rb human computer
```

You can mix and match these arguments as you like, allowing a `human` to play against another `human` or even a `computer` against another `computer`!