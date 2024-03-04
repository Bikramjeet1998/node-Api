# Use Node.js base image
FROM node:latest

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy rest of the application
COPY . .

# Install Chromium and its dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        chromium \
        libxss1 \
        libxtst6 \
        libnss3 \
        libasound2 \
        libatk-bridge2.0-0 \
        libgtk-3-0 \
        libgbm1 \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Expose the port
EXPOSE 80:3000

# Start the application
CMD ["node", "index.js"]
