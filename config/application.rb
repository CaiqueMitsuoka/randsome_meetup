require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module RandMeetup
  class Application < Rails::Application

  end
end
