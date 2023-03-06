---
layout: page
title: Payments Configuration
nav_order: 2
---
# Payments Configuration


- [Create a PayPal REST API Application](#create-a-paypal-rest-api-application)
  - [Create a Product](#create-a-product)
  - [Create a Plan](#create-a-plan)
- [Configure Webhooks](#configure-webhooks)
  - [Using the Rails Console](#using-the-rails-console)
  - [Using the PayPal Developer Dashboard](#using-the-paypal-developer-dashboard)
- [Use the Webhooks Simulator](#use-the-webhooks-simulator)
  - [Using `ngrok` for Local Webhook Testing](#using-ngrok-for-local-webhook-testing)
  - [Generate More Webhook Mocks](#generate-more-webhook-mocks)

## Create a PayPal REST API Application

Visit the [PayPal Developer Dashboard](https://developer.paypal.com/dashboard/applications/sandbox/create) 
and click "create app".

Back in a terminal, you'll need to add the paypal client id and secret obtained
in the above step:

```
EDITOR=vim rails credentials:edit
```

and populate the file with:

```yaml
paypal:
  client_id: abc123
  secret: xyz987
```

### Create a Product

Open a rails console and create a product:

```rb
product = PayPal::Product.create!(name: 'Example product', description: 'example product description')
```

### Create a Plan

In the same rails console session, create a plan:

```rb
plan = PayPal::Plan.create!(product_id: product.id, name: 'Example plan', description: 'example plan description')
```

## Configure Webhooks

This application will modify a user's subscription status when that user cancels
a plan on paypal.com.

{: .note }

Only the first webhook is used for verification. See `WebhooksController#create`
for more details about how incoming webhooks are verified. Notably,
`webhooks.first` is present.

### Using the Rails Console

```rb
PayPal::Webhook.create("https://saas-starter.app/webhooks")
```

### Using the PayPal Developer Dashboard

Visit the [developer dashboard](https://developer.paypal.com/dashboard/applications/sandbox)
and click on the application you created earlier. Click "add webhook". Set the 
webhook url to `https://saas-starter.app/webhooks`.

At the time of this writing (2023-03), only the `BILLING.SUBSCRIPTION.CANCELLED` event 
type is used to modify a user's subscription status in the application.

## Use the Webhooks Simulator

The [PayPal Webhooks Simulator](https://developer.paypal.com/dashboard/webhooksSimulator)
allows you to send test events like `BILLING.SUBSCRIPTION.CANCELLED` to a
staging or local environment to simulate buyer behaviors on paypal.com.

### Using `ngrok` for Local Webhook Testing

You can use `ngrok` to generate a public webhook url:

```
ngrok http 3000
# Forwarding https://123a-456-789-012-345.ngrok.io -> http://localhost:3000
```

For convenience, there is a commented out line in 
`config/environments/development.rb` that allows incoming requests from `ngrok`:

```rb
# config/environments/development.rb
config.hosts << /[a-z0-9\-]+\.ngrok\.io/
```

### Generate More Webhook Mocks

It might be useful to click around the application UI and see which events are
triggered by paypal. Use the following code to write a mock for each received
webhook.

```rb
File.write(
  "spec/mocks/paypal-webhook-" + params["event_type"] + ".json",
  JSON.pretty_generate(params.to_unsafe_hash)
)
```

