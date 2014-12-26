FROM ubuntu

RUN apt-get update -yqq && apt-get install -yqq ruby ruby-dev make nodejs
RUN gem install --no-rdoc --no-ri jekyll jekyll-sitemap rouge

VOLUME /blog
EXPOSE 4000

WORKDIR /blog
CMD ["jekyll", "server"]
