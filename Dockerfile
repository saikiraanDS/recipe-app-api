FROM python:3.9-alpine3.13

LABEL maintainer="koline"

ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Copy requirements first for caching purposes
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Define build argument for development
ARG DEV=false

# Create virtual environment and install dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser --disabled-password --no-create-home django-user

# Set PATH and switch user
ENV PATH="/py/bin:$PATH"
USER django-user

# Copy application code after dependencies are installed
COPY ./app /app

# Expose port for the application
EXPOSE 8000

# Optional: Add health check (adjust URL as necessary)
HEALTHCHECK CMD curl --fail http://localhost:8000/ || exit 1


 


