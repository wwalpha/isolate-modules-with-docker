# Source Docker Image
FROM node:10.16.0-alpine

ENV ROOT=/workspace
WORKDIR ${ROOT}

ADD package.json ${ROOT}

RUN npm i -g typescript && npm i -g yarn && yarn install
