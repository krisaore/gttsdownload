# config/initializers/load_config.rb
APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]
GOOGLE_URL = APP_CONFIG["google"]["url"]
GOOGLE_QUERY = APP_CONFIG["google"]["query"]
GOOGLE_TARGET_LANGUAGE = APP_CONFIG["google"]["target_language"]
LANGUAGES = APP_CONFIG["languages"].sort

