FROM ruby

# install require packages:
RUN apt-get update && apt-get install -y nodejs git python-pygments

# install gems:
RUN gem install jekyll kramdown rdiscount rouge --no-ri --no-rdoc

# set up blog:
RUN git clone https://github.com/paweloczadly/paweloczadly.github.io
RUN cd paweloczadly.github.io && bundle install

# start blog:
WORKDIR paweloczadly.github.io
CMD jekyll serve
EXPOSE 4000
