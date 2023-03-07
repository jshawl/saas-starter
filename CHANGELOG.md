# Changelog

## [2023-03-06](https://github.com/jshawl/saas-starter/releases/tag/v2023.03.06)

- Add webhook support for PayPal activity
  - Cancel subscriptions when a user cancels a subscription on paypal.com
- Add exception monitoring with sentry

## [2023-03-02](https://github.com/jshawl/saas-starter/releases/tag/v2023.03.02)

- Add `docker compose` for local development
- Add a `/docs` site, powered by Jekyll
- Use `ActiveConcern` for cached plans and pricing

## [2023-02-27](https://github.com/jshawl/saas-starter/releases/tag/v2023.02.27)

- Use Sendgrid via SMTP for ActionMailer
- `User.create` sends a welcome email
- Password reset emails are delivered and functional

## [2023-02-20](https://github.com/jshawl/saas-starter/releases/tag/v2023.02.20)

- Add Subscriptions

## [2023-02-19](https://github.com/jshawl/saas-starter/releases/tag/v2023.02.19)

- Add rubocop and fix offenses.
- Add one time payment with PayPal.

## [2023-01-07](https://github.com/jshawl/saas-starter/releases/tag/v2.1.0)

- remove stripe by @jshawl in [#16](https://github.com/jshawl/saas-starter/pull/16)
- upgrade ruby dependencies by @jshawl in [#17](https://github.com/jshawl/saas-starter/pull/17)

## [2022-07-22](https://github.com/jshawl/saas-starter/releases/tag/v2.0.1)

- Upgrade to rails 7.0.3.1
- Remove unused files from rails v6

## [2022-04-22](https://github.com/jshawl/saas-starter/releases/tag/v2.0.0)

- Upgrade to rails 7.
- Remove unused dependencies.
- Remove webpacker
- Setup importmaps
