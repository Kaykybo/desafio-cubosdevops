FROM node:24
WORKDIR /APP
COPY index.js /APP
COPY package.json /APP
RUN npm install 
EXPOSE 8080
CMD ["node", "index.js"]
