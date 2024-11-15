FROM node:20
WORKDIR /srv/app
EXPOSE 1337
CMD yarn install && yarn develop
# CMD tail -f /dev/null
