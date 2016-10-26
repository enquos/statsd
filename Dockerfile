FROM mhart/alpine-node:5

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json /usr/src/app/

RUN apk --no-cache add --virtual build-dep make gcc g++ python \
    && npm install \
    && apk del build-dep

RUN npm install
COPY . /usr/src/app

RUN \
  cp -v exampleConfig.js config.js && \
  sed -i 's/graphite.example.com/graphite/' config.js

EXPOSE 8125/udp
EXPOSE 8126

ENTRYPOINT [ "node", "stats.js", "config.js" ]
