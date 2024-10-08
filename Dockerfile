FROM node:14 AS builder

ENV NODE_ENV=production
ENV APP_HOME=/usr/src/app

WORKDIR ${APP_HOME}

COPY package*.json ./

RUN npm install --silent && \
    echo "Dependencies installed successfully."

COPY . .

# Install Wix CLI as a local development dependency
RUN npm install wix-cli --save-dev && \
    echo "Wix CLI installed successfully."

# Comment out the build command for now
# RUN npx wix-cli dev && \
#     echo "Application built successfully."

FROM node:14 AS production

ENV NODE_ENV=production
ENV APP_HOME=/usr/src/app

WORKDIR ${APP_HOME}

RUN useradd -ms /bin/bash appuser

COPY --from=builder ${APP_HOME}/package*.json ./

RUN npm install --silent --production && \
    echo "Production dependencies installed successfully."

RUN chown -R appuser:appuser ${APP_HOME} && \
    echo "Changed ownership to appuser."

USER appuser

ENV LOG_LEVEL=info

EXPOSE 3000

CMD ["npx", "wix-cli", "dev"]

HEALTHCHECK CMD curl --fail http://localhost:3000/health || exit 1

RUN npm cache clean --force && \
    echo "Cleaned npm cache."
