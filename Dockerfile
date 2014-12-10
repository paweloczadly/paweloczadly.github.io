FROM ubuntu

RUN apt-get update && apt-get install -y ruby ruby-dev build-essential node python-pygments
RUN gem install --no-rdoc --no-ri jekyll jekyll-sitemap rake

VOLUME /blog
EXPOSE 4000

WORKDIR /blog
CMD ["jekyll", "server", "-w"]
