#stage 1
FROM python:3.9-slim AS builder

WORKDIR /app/backend

COPY requirements.txt /app/backend
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*


# Install app dependencies
# RUN pip install mysqlclient
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/backend

#EXPOSE 8000
#RUN python manage.py migrate
#RUN python manage.py makemigrations

#Stage 2

FROM python:3.9-slim  

WORKDIR /app/backend

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copy installed dependencies from the builder stage
COPY --from=builder /usr/local/ /usr/local/
COPY --from=builder /app/backend /app/backend

EXPOSE 8000


