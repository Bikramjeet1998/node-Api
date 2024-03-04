# Step 1: Specify the base image
FROM node:latest

# Install Puppeteer dependencies
RUN apt-get update \
    && apt-get install -y wget gnupg ca-certificates procps \
      libxss1 libasound2 libatk-bridge2.0-0 libgtk-3-0 libgbm-dev \
      libnss3 libatk1.0-0 libcups2 libdrm2 libdbus-1-3 libxrandr2 \
      libxcomposite1 libxcursor1 libxi6 libxtst6

# Step 2: Set the working directory inside the container
WORKDIR /usr/src/app

# Step 3: Copy package.json and package-lock.json (if available) to the container
COPY package*.json ./

# Step 4: Install dependencies
RUN yarn install

# Step 5: Copy the rest of your application's source code to the container
COPY . .

# The application binds to port 3000. Expose this port.
EXPOSE 80:3000

# Define the command to run the app
CMD [ "node", "index.js" ]