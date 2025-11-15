# Use an official Python runtime as a base image
FROM python:3.11-slim

# Set working directory inside container
WORKDIR /app

# Copy project files into container
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port (if your app runs a server)
EXPOSE 5000

# Command to run your app
CMD ["python", "main.py"]
