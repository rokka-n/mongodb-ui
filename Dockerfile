FROM node:latest
MAINTAINER Roman Naumenko <roman@naumenko.ca>

RUN apt-get update -y
RUN apt-get install -y git gawk
RUN git clone https://github.com/mrvautin/adminMongo.git 

WORKDIR /adminMongo
RUN npm install

# Change port to something more meaningful
RUN gawk -i inplace '{ gsub("var app_port = 1234;", "var app_port = 8085;", $0); print}' app.js
RUN gawk -i inplace '{ gsub("mongodb://localhost:27017", "mongodb://mongo:27017", $0); print}' config/config.json

EXPOSE 8085 

CMD npm start
