# CMS

[![CircleCI](https://circleci.com/gh/obduk/cms.svg?style=svg)](https://circleci.com/gh/obduk/cms)

A Content Management System (CMS) written with Ruby on Rails. Although it is a
working project, it was not created with the intention of being a production
system. Instead this has been my practice project over the years, used for
testing new ideas.

## Development

1. `./bin/setup` to set up the system
1. `./bin/test` to run all tests or `./bin/test spec/models/user_spec.rb` to run one test or folder
1. `./bin/quality` to run code quality checks
1. `./bin/run` to start services
1. http://localhost:3000/ to access the site
1. http://localhost:3000/graphiql to view GraphQL api

## Deployment

Deplyoment is managed via [CircleCI](.circleci/config.yml) with the following manual steps:

### Heroku Addon PostgreSQL

```
heroku pg:backups:schedule --at '02:00 UTC' --app obduk-cms-production
```

### Heroku Addon Rollbar

1. Open Rollbar from Heroku app
1. Go to Settings
1. In general select a timezone
1. In source control enable Github
1. In project access tokens copy post_client_item token and run the following:

```
heroku config:set --app obduk-cms-production ROLLBAR_CLIENT_TOKEN=xxx
```

### Heroku Addon Scheduler

1. Open Heroku Scheduler from Heroku app
1. Add new job
1. Set command to `./bin/rails runner 'DailyJob.perform_now'`
1. Set frequency to daily

### Heroku Addon Scout

1. Open Scout from Heroku app
1. Go to alerts and set conditions, groups and channels
1. Go to app settings and set up Github integration
