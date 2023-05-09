database: postgres
redis: redis-server
mail: maildev --hide-extensions STARTTLS
web: bundle exec puma -C config/puma.rb
js: yarn build --watch
css: yarn build:css --watch
minio: minio server ~/buckets/management
background: bundle exec sidekiq -C config/sidekiq.yml
