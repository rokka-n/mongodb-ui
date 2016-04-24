[![Stories in Ready](https://badge.waffle.io/rokka-n/mongodb-ui.png?label=ready&title=Ready)](https://waffle.io/rokka-n/mongodb-ui)
# MongoDB dev environment with UI interface

I wanted to have an easy way to spin up mongodb environment with a choice of UI interfaces.

I'm going to use adminMongo, but it should be easy to add any existing.

# Tests

Install whatever ruby wants to run rspec/serverspec:

```
docker run --rm -ti \
       --net host  \
       --name ruby \
       -e BUNDLE_PATH=/usr/src/app/rubies \
       -e BUNDLE_BIN=/usr/src/app/rubies \
       -e BUNDLE_APP_CONFIG=/usr/src/app/rubies \
       -e GEM_HOME=/usr/src/app/rubies \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -v "$PWD":/usr/src/app \
       -e PATH=/usr/local/bundle/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/src/app:/usr/src/app/rubies \
       -w /usr/src/app ruby:2.1  \
       bundler install
```

And then run tests with ```rspec``` instead of ```bundler install```
