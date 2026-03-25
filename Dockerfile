# Use official Node.js LTS runtime
FROM node:22-slim

# Install Python and yt-dlp
USER root
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install "yt-dlp[default,curl-cffi]" --break-system-packages && \
    rm -rf /var/lib/apt/lists/*
USER node

# Set working directory
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY --chown=node:node package*.json ./
RUN npm install --omit=dev

# Copy app source
COPY --chown=node:node . .

# Hugging Face Spaces requires port 7860
ENV PORT=7860
EXPOSE 7860

# Start the addon
CMD [ "npm", "start" ]