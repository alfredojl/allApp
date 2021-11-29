FROM node:16.13.0-alpine3.13

WORKDIR /app
COPY . .
RUN npm i -g http-server && yarn install && yarn run build

CMD ["http-server", "-p", "80", "dist"]