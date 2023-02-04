# Use a Node.js base image so we don't have to install a bunch of extra things
FROM node:18 as development

WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files over
# We do this FIRST so that we don't copy the huge node_modules folder over from our local machine
# The node_modules can contain machine-specific libraries, so it should be created by the machine that's actually running the code
COPY package*.json ./

# Now we run NPM install, which includes dev dependencies
RUN npm install

# Copy the rest of our source code over to the image
COPY ./src ./src

EXPOSE 80

# Run our dev command, which uses nodemon to watch for changes (or in node 18 --watch flag)
CMD [ "npm", "run", "dev" ]

# "Builder" stage extends from the "development" stage but does an NPM clean install with only production dependencies 
FROM development as builder
WORKDIR /usr/src/app
RUN rm -rf node_modules
RUN npm ci --only=production
EXPOSE 80
CMD [ "npm", "start" ]

# Final stage uses a very small image and copies the built assets across from the "builder" stage
FROM alpine:latest as production
RUN apk --no-cache add nodejs ca-certificates
WORKDIR /root/
COPY --from=builder /usr/src/app ./
CMD [ "node", "src/index.js" ]