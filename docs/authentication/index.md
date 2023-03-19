---
layout: page
title: Authentication
nav_order: 2
---

# Authentication

There are two authentication options available:

- [Devise](https://github.com/heartcombo/devise) - provides email and password authentication
- [Auth0](https://auth0.com/) - provides email, sms, social, and more authentication

Both are included by default.

{: .note }

Choose Devise for the quickest setup. No 3rd party credentials are required to
authenticate users in your rails application.

## Devise

Devise uses session and registration controllers from the gem. The only configuration
required for this integration is a SendGrid SMTP credentials in `config/environment.rb`

## Auth0

Auth0 redirects all authentication requests to auth0.com  and responds with
omniauth data (uid, email, access token) through the `Auth0Controller` in this
application.

This integration uses a `User` model with many `identities`. Each oauth provider
gets its own identity.

The credentials required for the Auth0 integration are:

```yaml
auth0:
  client_id:
  client_secret:
  domain:
```

which can be configured via `EDITOR=vim rails credentials:edit`

## Auth0 UI Configuration

You will also need to add `http://localhost:3000/auth/auth0/callback` as an allowed
callback url in the auth0.com application configuration.
