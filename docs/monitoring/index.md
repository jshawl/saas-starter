---
layout: page
title: Monitoring
---

# Monitoring

- [Using fly logs](#using-fly-logs)
- [Using Sentry](#using-sentry)
  - [Configure Sentry](#configure-sentry)

## Using fly logs

```
fly logs
```

View the [fly logs documentation](https://fly.io/docs/flyctl/logs/).

## Using Sentry

Uncaught exceptions will be sent to [Sentry](https://sentry.io/) as long as there is a `sentry_dsn`
value present in rails credentials:

```
$ EDITOR=vim rails credentials:edit --environment=production
```

```yml
sentry_dsn: 'https://examplePublicKey@o0.ingest.sentry.io/0'
```

### Configure Sentry

This application has the default configuration inside of
`config/initializers/sentry.rb`. There are several more configuration options
available.

View the [Sentry Documentation](https://docs.sentry.io/platforms/ruby/guides/rails/).
