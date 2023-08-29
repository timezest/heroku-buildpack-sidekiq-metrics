# heroku-buildpack-sidekiq-metrics

This Heroku buildpack provides [sidekiq](https://github.com/mperham/sidekiq) metrics.

See also https://github.com/mperham/sidekiq/wiki/Monitoring

## How does it affect my slug?

This buildpack does two things:

1. Copies [.profile.d/ruby-sidekiq-metrics.sh](https://github.com/feedforce/heroku-buildpack-sidekiq-metrics/blob/master/.profile.d/ruby-sidekiq-metrics.sh) script into your slug
    * See also [Dynos and the Dyno Manager > Startup > The .profile file](https://devcenter.heroku.com/articles/dynos#the-profile-file)
1. Copies [sidekiq-metrics](https://github.com/feedforce/heroku-buildpack-sidekiq-metrics/blob/master/sidekiq-metrics) script into your slug

The `.profile.d/ruby-sidekiq-metrics.sh` script starts the `sidekiq-metrics` script on `web.1` Dyno boot.

The `sidekiq-metrics` script is called every `30` seconds and outputs the following log to stdout:

```
source=sidekiq queue=default size=3 latency=0 threshold=below
source=sidekiq queue=low size=42 latency=1 threshold=above
```

## Requirements

* [bundler](https://github.com/rubygems/bundler)
* [heroku/ruby](https://github.com/heroku/heroku-buildpack-ruby) buildpack
* [sidekiq](https://github.com/mperham/sidekiq)

## Customize

* `SIDEKIQ_METRICS_DYNO` (Default: `web.1`)
    * The Dyno name which the `sidekiq-metrics` script boot as daemon
* `SIDEKIQ_METRICS_INTERVAL` (Default: `30`)
    * Polling interval (seconds) which the `sidekiq-metrics` script is called
* `SIDEKIQ_METRICS_THRESHOLD` (Default: `30`)
    * Latency interval (seconds) that causes script to print whether threshold is exceeded or not
    * Can be a global threshold for all queues or separate value per queue (e.g. `default:30,low:300` or `30,low:300`)

## Configure from CLI

```
$ heroku buildpacks:add https://github.com/timezest/heroku-buildpack-sidekiq-metrics.git
```

## Configure from app manifest

```json
{
  "buildpacks": [
    {
      "url": "https://github.com/timezest/heroku-buildpack-sidekiq-metrics.git"
    }
  ]
}
```
