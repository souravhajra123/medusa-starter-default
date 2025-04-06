FROM node:latest

# Install dependencies needed for building native packages
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

RUN corepack enable && corepack prepare yarn@stable --activate

# Copy package files and install dependencies
COPY package*.json yarn.lock .yarnrc.yml ./
RUN yarn install

# Copy the rest of the app
COPY . .

# Set environment variable
ENV NODE_ENV=production
ENV MEDUSA_TELEMETRY_DISABLED=true
RUN yarn install

# Expose the default Medusa port
EXPOSE 9000

# Start Medusa
CMD ["yarn", "start"]
