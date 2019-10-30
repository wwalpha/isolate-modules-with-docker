# Source Docker Image
FROM node:10.16.0-alpine

ENV ROOT=/workspace
WORKDIR ${ROOT}

ADD package.json ${ROOT}
# 既存データ
RUN npm i -g typescript && npm i -g yarn && yarn install && \
  rm -rf package.json && rm -rf yarn.lock
