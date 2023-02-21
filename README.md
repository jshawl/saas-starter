# Ruby on Rails SaaS Starter Template

![Ruby](https://github.com/jshawl/saas-starter/actions/workflows/ruby.yml/badge.svg)

## Features & Includes

- Headless browser testing with rspec
  - GitHub actions run tests
- Devise authentication and User model
- Credit Card Payments with PayPal

## Local Setup

```
git clone git@github.com:jshawl/saas-starter.git
cd saas-starter
bundle install
```

`$ EDITOR=vim rails credentials:edit` to add/edit secrets

You'll need a paypal client id and secret:

```
paypal:
  client_id: abc123
  secret: xyz789
```

```
rails db:create db:migrate
```

### Running Tests

```
rake
```

### GitHub actions

Add a repository secret `RAILS_MASTER_KEY` on GitHub with the value from `config/master.key`.

## Monitoring & Maintenance

```
fly logs
fly ssh console -C "app/bin/rails console"
```
