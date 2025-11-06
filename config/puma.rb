# Threads
threads_count = ENV.fetch("RAILS_MAX_THREADS", 5).to_i
threads threads_count, threads_count

# Processes per worker
workers ENV.fetch("WEB_CONCURRENCY", 0)

# Rackup file
rackup "config.ru"

# Port
port ENV.fetch("PORT", 9292)

# Environment
environment ENV.fetch("RACK_ENV", "development")
