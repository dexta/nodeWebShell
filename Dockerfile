FROM loadimpact/k6 as cliapp

FROM node:8.12.0-jessie

COPY --from=cliapp /root/k6 /usr/bin/k6

WORKDIR /var/www

COPY package.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD [ "nodemon", "app.js" ]