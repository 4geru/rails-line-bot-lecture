# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.

Rails.application.configure do
  config.hosts << ".ngrok.io"
end

Rails.application.initialize!