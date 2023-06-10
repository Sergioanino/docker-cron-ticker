#. BUILDX
# docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 \
#    -t klerith/cron-ticker:latest --push .

#. /app /usr /lib
# FROM node:19.2-alpine3.16
FROM --platform=linux/amd64 node:19.2-alpine3.16
# FROM --platform=$BUILDPLATFORM node:19.2-alpine3.16

#. cd app
WORKDIR /app

#. Dest /app
COPY package.json ./

# COPY ../app.js ../package.json ./ # Sergio file docker.

#. Install dependencies
RUN npm install

#. Dest /app
COPY . .

#. Testing :
RUN npm run test

#. delete unless directory to production :
RUN rm -rf tests && rm -rf node_modules

#. DEP to production :
RUN npm install --prod

#. Commande to run image
CMD [ "node", "app.js" ]