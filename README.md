# Web feeds → Matrix notifications

An instance of [maubot] with the [rss] plugin in [standalone mode] on [Dokku].

## Deployment

### Provisioning

As a homeserver admin, create a user for the bot:

```bash
displayname="$(yq --raw-output '.user.displayname' 'config.yaml')"
avatar_url="$(yq --raw-output '.user.avatar_url' 'config.yaml')"

# Create bot user
http put "https://matrix.example.com/_synapse/admin/v2/users/$BOT_USER_ID" \
  Authorization:"Bearer $ADMIN_ACCESS_TOKEN" \
  user_type='bot' \
  displayname="$displayname" \
  avatar_url="$avatar_url"

# Get bot access token
http post "https://matrix.example.com/_synapse/admin/v1/users/$BOT_USER_ID/login" \
  Authorization:"Bearer $ADMIN_ACCESS_TOKEN" \
  --raw '{}'
```

Deploy to Dokku:

```bash
alias dokku='ssh -t dokku@dokku.seagl.org'

# Create and configure app
dokku apps:create 'maubot-rss'
dokku config:set 'maubot-rss' \
  MAUBOT_USER_CREDENTIALS_HOMESERVER='…' \
  MAUBOT_USER_CREDENTIALS_ID='…' \
  MAUBOT_USER_CREDENTIALS_ACCESS_TOKEN='…'

# Add persistent filesystem
dokku storage:ensure-directory 'maubot-rss-data'
dokku storage:mount 'maubot-rss' '/var/lib/dokku/data/storage/maubot-rss-data:/data'

# Build image and start service
git remote add 'production' 'dokku@dokku.seagl.org:maubot-rss'
git push 'production' 'main'
```

### Updates

Deploy to Dokku:

```bash
# Build updated image and replace running container
git push 'production' 'main'
```

## Usage

### Administration

Until [maubot/maubot#110](https://github.com/maubot/maubot/issues/110) is resolved, rooms can be joined by using a utility script:

```bash
dokku run maubot-rss ./join '#example:example.com'
```

### In Matrix rooms

List feeds and their ID numbers:

```
!feeds list
```

Add a feed:

```
!feeds subscribe https://example.com/atom.xml
```

Remove a feed:

```
!feeds unsubscribe 12345
```

Customize the messages of a feed:

```
!feeds template 12345 The post [$title]($link) has been published.
```

[Dokku]: https://dokku.com/
[maubot]: https://maubot.xyz/
[rss]: https://github.com/maubot/rss
[standalone mode]: https://docs.mau.fi/maubot/usage/standalone.html
