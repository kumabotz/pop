# [pop](http://playpop.herokuapp.com/) [![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/kumabotz/pop/trend.png)](https://bitdeli.com/free "Bitdeli Badge") [![Build Status](https://travis-ci.org/kumabotz/pop.png?branch=master)](https://travis-ci.org/kumabotz/pop) [![Code Climate](https://codeclimate.com/github/kumabotz/pop.png)](https://codeclimate.com/github/kumabotz/pop)

![](https://raw.github.com/kumabotz/pop/master/app/assets/images/yo.png)

![](https://raw.github.com/kumabotz/pop/master/app/assets/images/game.png)

## Setup [![Hack kumabotz/pop on Nitrous.IO](https://d3o0mnbgv6k92a.cloudfront.net/assets/hack-s-v1-7475db0cf93fe5d1e29420c928ebc614.png)](https://www.nitrous.io/hack_button?source=embed&runtime=rails&repo=kumabotz%2Fpop&file_to_open=README.md)

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

## ProTip

[Speed up rails testing](http://railscasts.com/episodes/412-fast-rails-commands)

1. `gem install zeus`
1. `zues start`

Deploy to Heroku from another computer

1. Install heroku client `curl https://toolbelt.heroku.com/install.sh | sh`
1. `heroku login`
1. `git remote add <heroku repo.git>`
1. `heroku keys:add`
1. `git push heroku master`

## TODO
- [x] Convert into [rails app](http://playpop.herokuapp.com/)
- [x] Deploy to [heroku](http://playpop.herokuapp.com/)
- [x] Add nitrous [HACK button](https://www.nitrous.io/hack_button?source=embed&runtime=rails&repo=kumabotz%2Fpop&file_to_open=README.md)
- [x] Add Google Analytic
- [x] Setup [foundation](http://foundation.zurb.com/)
- [x] [Responsive layout](http://thesassway.com/intermediate/responsive-web-design-in-sass-using-media-queries-in-sass-32)
- [x] Use [BEM](http://bem.info/)
- [x] Add custom font
- [x] Add [Fontello](http://fontello.com/)
- [x] Use [coffeescripts](http://coffeescript.org/)
- [x] Setup tests
- [ ] Update JS architecture

## References
- [How To Design A Mobile Game With HTML5](http://mobile.smashingmagazine.com/2012/10/19/design-your-own-mobile-game/)
- [Ruby on Rails Tutorial](http://www.railstutorial.org/book)
