# frozen_string_literal: true

module MarsRover
  class Base
    attr_reader :errors

    def initialize
      @errors = []
    end

    def error_messages
      return if errors.empty?

      message = "\e[31m⛔️ Errrr, "
      message += errors.map { |error| "#{error.keys.last.capitalize} #{error.values.last}" }.join(', ')
      message += "\e[0m"
      message
    end

    def valid?
      validate && errors.empty?
    end

    def invalid?
      !valid?
    end

    private

    # Returns true or false.
    def validate
      raise NotImplementedError, 'Subclasses must implement a validate method'
    end
  end
end
