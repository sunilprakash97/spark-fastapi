# Use an official Python runtime as a parent image
FROM python:3.9.12

# Set the working directory to /app
WORKDIR /app

# Copy the requirements.txt file into the container at /app
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install Java and Scala
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk scala && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Set the SCALA_HOME environment variable
ENV SCALA_HOME=/usr/share/scala

# Set the PYSPARK_PYTHON environment variable to use the Python 3 interpreter
ENV PYSPARK_PYTHON=python3

# Set the SPARK_HOME environment variable
ENV SPARK_HOME=/spark

# Download and extract Spark
RUN curl -O https://archive.apache.org/dist/spark/spark-3.2.0/spark-3.2.0-bin-hadoop3.2.tgz && \
    tar -xzf spark-3.2.0-bin-hadoop3.2.tgz && \
    mv spark-3.2.0-bin-hadoop3.2 /spark && \
    rm spark-3.2.0-bin-hadoop3.2.tgz

# Set the PATH environment variable to include Spark and Scala binaries
ENV PATH $PATH:$SPARK_HOME/bin:$SCALA_HOME/bin

# Copy the rest of the application code into the container at /app
COPY . .

# Expose port 8000 for the FastAPI app
EXPOSE 8000

# Run the command to start the FastAPI app
CMD ["python","FastAPI_Server.py"]