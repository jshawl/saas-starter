# Ruby on Rails SaaS Starter Template

![Ruby](https://github.com/jshawl/saas-starter/actions/workflows/ruby.yml/badge.svg)

## Motivation

I'm tired of Frankensteining a bunch of existing code from other apps to create
new SaaS projects. I want to templatize all the things I usually add to new SaaS projects and make it as easy as possible to start hacking on an idea and collect money for it.

## Features & Includes

- Headless browser testing with rspec
  - GitHub actions run tests
- Devise authentication and User model

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

`$ EDITOR=vim rails credentials:edit` to add/edit secrets

```
rails db:create db:migrate
```

### Running Tests

```
rake
```

### GitHub actions

Add a repository secret `RAILS_MASTER_KEY` on GitHub with the value from `config/master.key`.
