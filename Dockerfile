FROM node:14 AS builder

ENV NODE_ENV=production
ENV APP_HOME=/src

WORKDIR ${APP_HOME}

COPY package*.json ./

RUN npm install --silent && echo "Dependencies installed successfully."

COPY . .

RUN npm install wix-cli --save-dev && echo "Wix CLI installed successfully."


FROM node:14 AS production

ENV NODE_ENV=production
ENV APP_HOME=/src

WORKDIR ${APP_HOME}

RUN useradd -ms /bin/bash appuser

COPY --from=builder ${APP_HOME} ./

RUN npm install --silent --production && echo "Production dependencies installed successfully."
RUN chown -R appuser:appuser ${APP_HOME} && echo "Changed ownership to appuser."

USER appuser
ENV LOG_LEVEL=info
EXPOSE 3000

CMD ["npx", "wix-cli", "dev"]
HEALTHCHECK CMD curl --fail http://localhost:3000/health || exit 1
RUN npm cache clean --force && echo "Cleaned npm cache."
