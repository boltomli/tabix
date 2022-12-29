FROM node:18 AS builder
WORKDIR /app
COPY * ./
COPY app app
COPY webpack webpack
RUN echo 'nodeLinker: node-modules' > .yarnrc.yml
RUN yarn set version 3.1.1
RUN yarn install && npx browserslist@latest --update-db && yarn build

FROM nginx:alpine
COPY default.conf /etc/nginx/conf.d
WORKDIR /app
COPY --from=builder /app/dist .
ENTRYPOINT ["nginx", "-g", "daemon off;"]
