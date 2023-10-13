# Use an official Node runtime as a parent image
FROM node:14 as build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install Angular CLI globally
RUN npm install -g @angular/cli

# Install project dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Angular application
RUN ng build --prod

# Use a smaller base image for the final image
FROM nginx:alpine

# Copy the built Angular application to the web server directory
COPY --from=build /app/dist/* /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Command to run the Nginx server
CMD ["nginx", "-g", "daemon off;"]
