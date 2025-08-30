# ----------------------------
# Base Image
# ----------------------------
FROM python:3.12-slim AS base

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# ----------------------------
# Install Python Dependencies
# ----------------------------
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# ----------------------------
# Copy Application Code
# ----------------------------
COPY . .

# Create a non-root user
RUN useradd -m appuser
USER appuser

# ----------------------------
# Expose Port & Command
# ----------------------------
EXPOSE 8000
CMD ["gunicorn", "edutrack360.wsgi:application", "--bind", "0.0.0.0:8000"]
