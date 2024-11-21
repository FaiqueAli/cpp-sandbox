# Start with an official Ubuntu base image
FROM ubuntu:latest

# Install build essentials (includes g++ for C++ compilation)
RUN apt-get update && \
    apt-get install -y build-essential && \
    rm -rf /var/lib/apt/lists/*
RUN apt update
RUN apt install -y git

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Build the C++ calculator application
#RUN make
# RUN compile.sh

# Specify the command to run when the container starts
CMD ["/bin/bash"]
