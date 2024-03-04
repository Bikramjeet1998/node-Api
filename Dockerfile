# Use Node as the base image
FROM node:latest

# Install system dependencies for Puppeteer
RUN apt-get update \
    && apt-get install -y wget gnupg ca-certificates procps \
      libxss1 libasound2 libatk-bridge2.0-0 libgtk-3-0 libgbm-dev \
      libnss3 libatk1.0-0 libcups2 libdrm2 libdbus-1-3 libxrandr2 \
      libxcomposite1 libxcursor1 libxi6 libxtst6

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (or yarn.lock) into the container
COPY package*.json ./

# Install dependencies
RUN yarn install

# Copy the rest of the application source code
COPY . .

# Build the Next.js application
RUN yarn run build

# The application binds to port 3000. Expose this port.
EXPOSE 80:3000

# Define the command to run the app
CMD [ "yarn", "start" ]