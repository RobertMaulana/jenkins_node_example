FROM node:10

# Create app directory
WORKDIR /usr/src/app

# ENV BUILD_TAG=crowde-apps-258709
# ENV IMAGE_NAME=robertmaulana/jenkins_node_example
# ENV GCR_HOST=https://gcr.io

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

EXPOSE 8081
CMD [ "node", "server.js" ]