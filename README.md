# Ruby on Rails SaaS Starter Template

## Motivation

I'm tired of Frankensteining a bunch of existing code from other apps to create
new SaaS projects. I want to templatize all the things I usually add to new SaaS projects and make it as easy as possible to start hacking on an idea and collect money for it.

## Features & Includes

- Headless browser testing with rspec
  - GitHub actions run tests
- Devise authentication and User model
- Stripe Checkout

## Goals & Vision

Provide a starting point for new service experiments. Include tested examples of the following features:

- Metered Billing
- Plan Subscription Billing
- Functionality is restricted for those in dunning

## Local Setup

```
git clone git@github.com:jshawl/saas-starter.git
cd saas-starter
bundle install
```

`$ rails credentials:edit` and add the following:

```
stripe:
  public_api_key: pk_test_your_public_key_here
  secret_key: pk_test_your_secret_key_here
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