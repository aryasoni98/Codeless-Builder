FROM node:lts as dependencies
WORKDIR /
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

FROM node:lts as builder
WORKDIR /
COPY . .
COPY --from=dependencies /node_modules ./node_modules
RUN yarn build

FROM node:lts as runner
WORKDIR /
ENV NODE_ENV production
# If you are using a custom next.config.js file, uncomment this line.
# COPY --from=builder //next.config.js ./
COPY --from=builder /public ./public
COPY --from=builder /.next ./.next
COPY --from=builder /node_modules ./node_modules
COPY --from=builder /package.json ./package.json

EXPOSE 3000
CMD ["yarn", "start"]