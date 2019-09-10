require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner[:mongoid].strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.before(:all) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    DatabaseCleaner[:mongoid].clean
  end

  config.after(:all) do
    DatabaseCleaner.clean
    DatabaseCleaner[:mongoid].clean
  end
end

