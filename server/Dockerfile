FROM node:22-alpine

RUN apk add curl && \
    rm -rf /var/cache/apk/*

WORKDIR /app

COPY ./package.json .
COPY ./package-lock.json .

RUN npm ci

COPY ./ .

EXPOSE 5000

ENTRYPOINT [ "npm", "run", "server" ]