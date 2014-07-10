# [pop](http://popy.herokuapp.com/) [![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/kumabotz/pop/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

source: http://mobile.smashingmagazine.com/2012/10/19/design-your-own-mobile-game/

![](https://raw.github.com/kumabotz/pop/master/game.png)

## Development Setup

You'll need these installed in your box:

1. Ruby 2.1.2 (or higher): use [RVM](https://rvm.io/)
   - `curl -L https://get.rvm.io | bash -s stable`
   - `rvm install 2.1.2`
   - `rvm use 2.1.2 --default`
1. bundler: `gem install bundler --no-ri --no-rdoc`

And then do these:

1. Setup RVM project file: `rvm --ruby-version use 2.1.2@pop --create`
1. Install gem dependencies: `bundle install`
1. Run the :star2: Rails app: `bundle exec rails s`

## TODO
- [x] convert into [rails app](http://popy.herokuapp.com/)
- [x] deploy to [heroku](http://popy.herokuapp.com/)
- [ ] setup test
- [ ] responsive layout ([foundation](http://foundation.zurb.com/))
