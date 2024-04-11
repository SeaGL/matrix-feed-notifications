# Web feeds → Matrix notifications

An instance of [maubot] with the [rss] plugin in [standalone mode] on [Dokku].

## Deployment

GitHub Actions is [configured](./.github/workflows/deployment.yml) to automatically deploy from [`main`](https://github.com/SeaGL/matrix-feed-notifications/tree/main).

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
