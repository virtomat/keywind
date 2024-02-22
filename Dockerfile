FROM node:20-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
COPY . /app
WORKDIR /app

FROM base AS build
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install
RUN pnpm run build
RUN pnpm run build:jar


FROM busybox
COPY --chown=nobody --from=build /app/out/keywind.jar /home/keywind-virtomat.jar
CMD "sh"
