FROM dock.mau.dev/maubot/maubot:v0.5.2-standalone

ENV VERSION=0.4.1

# Plugin dependencies (as in maubot.yaml)
RUN apk add --no-cache \
  py3-feedparser

# Plugin
RUN cd /tmp \
  && wget https://github.com/maubot/rss/archive/refs/tags/v$VERSION.zip \
  && unzip v$VERSION.zip \
  && mv --target-directory /opt/maubot --verbose \
    rss-$VERSION/maubot.yaml \
    rss-$VERSION/rss \
  && rm -r v$VERSION.zip rss-$VERSION

# Configuration
COPY config.yaml join /opt/maubot/

# Start
USER 32767:32767
WORKDIR /opt/maubot
CMD ["sh", "-c", " \
  cp /opt/maubot/config.yaml /tmp/mutable-config.yaml \
  && python3 -m maubot.standalone -c /tmp/mutable-config.yaml \
"]
