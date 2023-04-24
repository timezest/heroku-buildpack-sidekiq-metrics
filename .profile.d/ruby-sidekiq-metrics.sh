#!/bin/bash -eu

# For development: from within your Rails application execute commands below
# $ REDIS_URL=redis://localhost:6379 DYNO=web.1 /path/to/.profile.d/ruby-sidekiq-metrics.sh /path/to/sidekiq-metrics
# $ REDIS_PATH=unix:///tmp/redis.sock DYNO=web.1 /path/to/.profile.d/ruby-sidekiq-metrics.sh /path/to/sidekiq-metrics

SIDEKIQ_METRICS=${1:-/app/bin/sidekiq-metrics}
SIDEKIQ_METRICS_DYNO=${SIDEKIQ_METRICS_DYNO:-web.1}
SIDEKIQ_METRICS_INTERVAL=${SIDEKIQ_METRICS_INTERVAL:-30}
SIDEKIQ_METRICS_THRESHOLD=${SIDEKIQ_METRICS_THRESHOLD:-30}

setup_metrics() {
  # Collect Sidekiq metrics on only one Dyno
  if [ "$DYNO" != "$SIDEKIQ_METRICS_DYNO" ]; then
    return 0
  fi

  # Collect Sidekiq metrics if Redis connection is defined
  if [ -z "$REDIS_PATH" ] && [ -z "$REDIS_URL" ]; then
    return 0
  fi

  if [ ! -x "$SIDEKIQ_METRICS" ]; then
    echo "No sidekiq-metrics executable found. Not starting."
    return 1
  fi

  echo "sidekiq-metrics start..."
  (while true; do
     "$SIDEKIQ_METRICS" "$SIDEKIQ_METRICS_THRESHOLD"
     sleep "$SIDEKIQ_METRICS_INTERVAL"
   done) &
}

setup_metrics
