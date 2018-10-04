FROM loadimpact/k6:latest as cliapp

FROM node:8.12.0-jessie

COPY --from=cliapp /usr/bin/k6 /usr/bin/k6

WORKDIR /var/www

COPY package.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD [ "npm", "run", "app" ]