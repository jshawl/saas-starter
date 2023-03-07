---
layout: page
title: Getting Started
nav_order: 1
---

# Getting Started

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

```
docker compose exec web bin/bundle exec rails db:create db:migrate
```
