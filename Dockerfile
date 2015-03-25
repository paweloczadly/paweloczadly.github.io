FROM ruby

RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs

RUN gem install jekyll jekyll-sitemap rouge
RUN gem install octopress -v '~> 3.0.0.rc.12'

WORKDIR /blog
