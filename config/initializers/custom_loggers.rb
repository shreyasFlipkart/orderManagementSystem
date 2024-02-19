# config/initializers/custom_loggers.rb

# Access Logger Configuration
access_log_file = File.join(Rails.root, 'log', "#{Rails.env}_access.log")
access_logger = ActiveSupport::Logger.new(access_log_file)
access_logger.formatter = Logger::Formatter.new
Rails.application.config.access_logger = ActiveSupport::TaggedLogging.new(access_logger)

# Error Logger Configuration
error_log_file = File.join(Rails.root, 'log', "#{Rails.env}_error.log")
error_logger = ActiveSupport::Logger.new(error_log_file)
error_logger.formatter = Logger::Formatter.new
Rails.application.config.error_logger = ActiveSupport::TaggedLogging.new(error_logger)

# Application Logger Configuration
application_log_file = File.join(Rails.root, 'log', "#{Rails.env}_application.log")
application_logger = ActiveSupport::Logger.new(application_log_file)
application_logger.formatter = Logger::Formatter.new
Rails.application.config.application_logger = ActiveSupport::TaggedLogging.new(application_logger)
