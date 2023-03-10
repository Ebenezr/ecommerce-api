FROM node:18-slim AS development

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

# Install Node dependencies
RUN yarn install  --only=development

COPY . .

# RUN apt-get update -y \ && apt-get install -y openssl

RUN yarn build


FROM node:18-slim AS production

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN yarn install --only=production



COPY . .
COPY --from=development /usr/src/app/prisma ./prisma
COPY --from=development /usr/src/app/dist ./dist

# LABEL "Ebenezar Blind <ebenezarbukosia@gmail.com>" \
#     Description="Lightweight container with Node 19 based on Alpine Linux"

# Set environment variables for your PostgreSQL and Redis databases
ENV POSTGRES_HOST=postgres-db-soko
ENV POSTGRES_PORT=5432
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=esoko_DB
ENV REDIS_HOST=localhost
ENV DATABASE_URL=postgresql://postgres:postgres@postgres-db-soko:5432/esoko_DB?schema=public&connect_timeout=300
ENV REDIS_PORT=6379
ENV CLOUDINARY_CLOUD_NAME=dbkeoqmg5
ENV CLOUDINARY_API_KEY=784643547226384
ENV CLOUDINARY_API_SECRET=8kI5-lZFW4b6dRhbXS0PI1hO51Y

EXPOSE 5000

CMD ["/bin/sh","-c", "sleep 20 && npm run start:prod"]


