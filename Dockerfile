FROM node:latest as builder

WORKDIR /app
RUN git clone https://github.com/JDAV-Bayern/fahrtkostenabrechnung.git
# Build the angular application for prod    
RUN cd fahrtkostenabrechnung && yarn install --frozen-lockfile && yarn build

FROM nginx:alpine as runner
# copy static files from builder
COPY --from=builder /app/fahrtkostenabrechnung/dist/portal-jdav-bayern/browser/de /etc/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY fahrtkostenabrechnung.conf /etc/nginx/conf.d/fahrtkostenabrechnung.conf