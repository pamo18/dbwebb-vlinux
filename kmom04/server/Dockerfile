FROM node:8

WORKDIR /server

COPY package*.json ./

RUN npm install

COPY express/ .

CMD [ "npm", "start" ]
