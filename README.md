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

## Plan Management

Plans default to $1 for getting up and running as quickly as possible. See `lib/pay_pal/plan.rb` for customizing plan creation options.

```
product = PayPal::Product.create!(name: 'Example product', description: 'example product description')
plan = PayPal::Plan.create!(product_id: product.id, name: 'Example plan', description: 'example plan description')
```

### Running Tests

```
rake
```

## Docs

The docs site is a Jekyll site. You can cd into `docs/` and run `jekyll serve` to edit the site locally.

During deployment, `jekyll build` is run inside the Dockerfile and copied into `public/docs`.


### GitHub actions

Add a repository secret `RAILS_MASTER_KEY` on GitHub with the value from `config/master.key`.

## Monitoring & Maintenance

```
fly logs
fly ssh console -C "app/bin/rails console"
```
