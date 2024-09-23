# Use Node.js base image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Install dependencies, including Medusa
RUN npm install @medusajs/medusa-cli --global

# Copy the rest of the application code
COPY . .

# Expose the port that Medusa will run on
EXPOSE 9000

# Set environment variables for PostgreSQL connection
ENV DATABASE_TYPE=postgres
ENV DATABASE_URL=postgres://medusa_yash:root@postgres:5432/medusa_db

# Run the Medusa server
CMD ["npm", "run", "start"]
