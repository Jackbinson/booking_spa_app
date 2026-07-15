FROM node:22-alpine

WORKDIR /app

RUN corepack enable

COPY package.json pnpm-lock.yaml* pnpm-workspace.yaml ./
RUN pnpm install --prod --frozen-lockfile

COPY . .

EXPOSE 3001

CMD ["pnpm", "start"]
