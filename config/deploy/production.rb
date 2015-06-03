set :rails_env, 'production'

set :host, ENV['host']

server fetch(:host), user: 'exec-repofs', roles: %w{app db web}