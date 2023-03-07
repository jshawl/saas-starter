# Ruby on Rails SaaS Starter Template

![Ruby](https://github.com/jshawl/saas-starter/actions/workflows/ruby.yml/badge.svg)

## Features & Includes

- Headless browser testing with rspec
  - GitHub actions run tests
- Devise authentication and User model
- Credit Card Payments with PayPal

## Documentation

The docs site is a Jekyll site. You can cd into `docs/` and run `jekyll serve` to edit the site locally.

During deployment, `jekyll build` is run inside the Dockerfile and copied into `public/docs`.

View [the documentation](https://saas-starter.app/docs/).

## Setup & Installation

See <https://saas-starter.app/docs/getting-started/>

## PayPal Plan Management

See [Payments Configuration](https://saas-starter.app/docs/payments/)

### Running Tests

```
rake
# or
bundle exec rspec
```

### GitHub actions

Add a repository secret `RAILS_MASTER_KEY` on GitHub with the value from `config/master.key`.

## Monitoring & Maintenance

See <https://saas-starter.app/docs/monitoring/>

## License

This project uses the [MIT License](https://opensource.org/license/mit/).
