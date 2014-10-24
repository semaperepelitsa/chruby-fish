function chruby
  switch "$argv"
  case ''
    ls $rubies
  case -h --help
    echo "usage: chruby [VERSION|system]"
  case system
    chruby_reset
  case '*'
    set -l name $argv[1]
    set -l dir (chruby_find $name; or chruby_find ruby-$name)

    if test ! -n "$dir"
      echo "chruby: unknown Ruby: $name"
      return 1
    end

    chruby_reset
    chruby_use $dir
  end
end

function chruby_find
  set -l rubies $RUBIES
  if test ! -n "$rubies"
    set rubies (ls -d $HOME/.rubies/* /opt/rubies/*)
  end

  for ruby in $rubies
    if test (basename $ruby) = $argv[1]
      echo $ruby
      return 0
    end
  end
  return 1
end

# Erase all variables set by chruby and revert PATH.
function chruby_reset
  # Remove all PATH additions.
  if test -n "$RUBY_ROOT"
    set -xg PATH (
      printf "%s\n" $PATH |\
      grep -Fxv $RUBY_ROOT/bin |\
      grep -Fxv $GEM_ROOT/bin |\
      grep -Fxv $GEM_HOME/bin
    )
  end

  set -e RUBY_ROOT
  set -e RUBY_ENGINE
  set -e RUBY_VERSION
  set -e GEM_HOME
end

# Add specified Ruby and its gems to PATH.
# Set GEM_HOME (gem install path) to e. g. ~/.gem/ruby/2.1.0
# Also set RUBY_ROOT, RUBY_ENGINE, RUBY_VERSION for your own use.
function chruby_use
  set -g RUBY_ROOT $argv
  set -xg PATH $RUBY_ROOT/bin $PATH

  # Get info from ruby.
  set -l ruby_code "puts RUBY_ENGINE, RUBY_VERSION, Gem.default_dir"
  set -l ruby_vars (ruby -e $ruby_code)

  set -g RUBY_ENGINE $ruby_vars[1]
  set -g RUBY_VERSION $ruby_vars[2]
  set -g GEM_ROOT $ruby_vars[3]

  set -xg GEM_HOME $HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION

  if test -d $GEM_ROOT/bin
    set -xg PATH $GEM_ROOT/bin $PATH
  end

  set -xg PATH $GEM_HOME/bin $PATH
end
