# Use Node.js as base image
FROM node:16-alpine

# Set working directory inside the container
WORKDIR /app

# Install required packages for PostgreSQL client
RUN apk add --no-cache bash libpq

# Install Medusa CLI globally
RUN npm install -g @medusajs/medusa-cli

# Copy package.json and package-lock.json (or yarn.lock)
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of your application code
COPY . .

# Expose the port Medusa will run on
EXPOSE 9000

# Run Medusa in development mode using the CLI
CMD ["npx", "medusa", "develop"]
