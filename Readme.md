Install from source:

    git clone https://github.com/semaperepelitsa/chruby-fish.git
    cd chruby-fish
    set -U fish_function_path $fish_function_path $PWD/share/chruby/functions

Usage:

    > ruby-install ruby 2.6.5
    installing into ~/.rubies/ruby-2.6.5
    > chruby 2.6.5
    > which ruby
    /Users/sema/.rubies/ruby-2.6.5/bin/ruby
    > ruby -v
    ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin18]
    > gem env
    - INSTALLATION DIRECTORY: /Users/sema/.gem/ruby/2.6.0
    - USER INSTALLATION DIRECTORY: /Users/sema/.gem/ruby/2.6.0

See also:

- [ruby-install](https://github.com/postmodern/ruby-install)
