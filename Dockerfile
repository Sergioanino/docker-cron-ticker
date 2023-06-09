#. BUILDX
# docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 \
#    -t sergioanino/cron-ticker:latest --push .

#- Dependence de développement.
FROM node:19.2-alpine3.16 as deps
# FROM --platform=$BUILDPLATFORM node:19.2-alpine3.16
WORKDIR /app 
COPY package.json ./
RUN npm install

#- Testing & Build app.
FROM node:19.2-alpine3.16 as builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run test

#- Dependence de production.
FROM node:19.2-alpine3.16 as prod-deps
WORKDIR /app
COPY package.json ./
RUN npm install --prod

#- Exécuter l'application
FROM node:19.2-alpine3.16 as runner
WORKDIR /app
COPY --from=prod-deps /app/node_modules ./node_modules
COPY app.js ./
COPY tasks/ ./tasks
CMD [ "node", "app.js" ]