FROM node:25-alpine AS base

RUN apk add --no-cache openssl
RUN npm install -g pnpm

WORKDIR /app

FROM base AS dependencies

COPY package.json pnpm-*.yaml ./

RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm fetch

FROM dependencies AS builder

COPY prisma ./prisma

RUN pnpm install --offline
RUN pnpm db:generate

COPY . .

RUN pnpm build
RUN pnpm prune --prod

FROM node:25-alpine AS production

RUN apk add --no-cache openssl

ENV NODE_ENV=production

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma

EXPOSE 5000

CMD ["node", "dist/main.js"]
