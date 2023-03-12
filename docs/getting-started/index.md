---
layout: page
title: Getting Started
nav_order: 1
---

# Getting Started

- [Local Setup](#local-setup)
- [Application Configuration](#application-configuration)
- [Getting a Clean Slate](#getting-a-clean-slate)
  - [Without the Version Control History](#without-the-version-control-history)
  - [Replacing References to SaaS Starter](#replacing-references-to-saas-starter)

## Local Setup

```
git clone git@github.com:jshawl/saas-starter.git
cd saas-starter
docker compose up --build
docker compose exec web bash
```

`$ EDITOR=vim rails credentials:edit` to add/edit secrets

You'll need a [PayPal client id and secret](https://developer.paypal.com/docs/checkout/standard/integrate/) as well as a [SendGrid API Key](https://docs.sendgrid.com/api-reference/api-keys/create-api-keys) with full Mail access:

```
paypal:
  client_id: abc123
  secret: xyz789
sendgrid: def456
```

## Application Configuration

You can configure application constants like the domain name, title, and GitHub
URL. All of these are configured inside of `config/application.rb`:

```rb
module Starter
  class Application < Rails::Application
    # ... all the other config.* lines ...
    config.title = "SaaS Starter"
    config.domain = "saas-starter.app"
    config.github_url = "https://github.com/jshawl/saas-starter"
  end
end
```

```
docker compose exec web bin/bundle exec rails db:create db:migrate
```

## Getting a Clean Slate

So you want to use this template for a propietary project with no connection back
to the `saas-starter` project? This section is for you.

### Without the Version Control History

Instead of [using the template](https://github.com/jshawl/saas-starter/generate),
you can
[download a zip file](https://github.com/jshawl/saas-starter/archive/refs/heads/ma.zip)
of the source code or 
[download a zipfile or tarball](https://github.com/jshawl/saas-starter/releases/latest)
from the latest release.

### Replacing References to SaaS Starter

In order to find all the references, use `git grep`:

```
git grep -in starter
```

There's a rake task available to make this as easy as possible:

```
$ rake clean_slate
```

but you'll probably need to update a few things here or there.
