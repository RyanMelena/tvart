# syntax=docker/dockerfile:1

FROM node:16 AS node_builder
COPY package.json package-lock.json ./
RUN npm install
COPY src src
RUN npm run build

FROM python:3-slim
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY --from=node_builder build build
COPY app.py app.py

# Define an environment variable for the port with a default value
ENV PORT=8080

EXPOSE ${PORT}/tcp

CMD [ "waitress-serve", "--port=$(PORT)", "app:app" ]
