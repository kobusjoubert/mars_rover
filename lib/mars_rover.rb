# frozen_string_literal: true

require 'active_support'
require 'active_support/environment_inquirer'
require 'active_support/core_ext/enumerable'
require 'debug'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem

module MarsRover
  class << self
    def env
      @_env ||= ActiveSupport::EnvironmentInquirer.new(
        ENV['MARS_ROVER_ENV'].presence || 'production'
      )
    end
  end
end

if MarsRover.env.development?
  loader.log!
  loader.enable_reloading
end

loader.setup
loader.eager_load

if MarsRover.env.development?
  require 'listen'

  Listen.to('lib') { loader.reload }.start
end
