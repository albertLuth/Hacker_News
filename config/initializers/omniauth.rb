OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '148409018359-d4qugam6ut9gb8nb6vns983qnbfv0o8l.apps.googleusercontent.com', 'm04lGijOcVZPgmSMTHt-ABpM', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end