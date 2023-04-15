---
layout: page
title: Admin UI
nav_order: 2
---

## Admin UI

As the owner of this application, you probably want to be able to do things
that end-users should _not_ be able to do. Admin users can be configured
by updating the `is_admin` user attribute to `true` in the rails console:

```rb
User.first.update(is_admin: true)
```

There is an admin namespace in `config/routes.rb` that defines an `/admin`
route.

Try it out locally by visiting <http://localhost:3000/admin>. Unauthorized
users will receive a 404.
