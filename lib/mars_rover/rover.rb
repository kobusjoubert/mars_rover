# frozen_string_literal: true

module MarsRover
  class Rover < Base
    CARDINAL_POINTS = %w[N E S W].freeze
    ROVER_MODELS = %w[🚜 🚑 🛵 🛺 🚲 🚒 🛴 🚎].freeze
    ROVER_ERRORS = %w[💥 🪦].freeze

    attr_reader :id, :plateau, :position, :x, :y, :direction, :instructions, :valid, :last_known_coordinates

    def initialize(id:, plateau:)
      super()
      @id = id
      @plateau = plateau
      @valid = { position: false, instructions: false }
      @last_known_coordinates = { x: nil, y: nil }
    end

    def position=(value)
      @position = value.strip.gsub(/\s+/, ' ')
      @x, @y, @direction = position.split.compact_blank
      @x = x.presence&.to_i
      @y = y.presence&.to_i
      @direction = direction&.upcase
    end

    def instructions=(value)
      @instructions = value.strip.gsub(/\s+/, '').upcase
    end

    def deploy!
      if plateau.grid[y - 1][x - 1].to_i >= 1
        position_error!("#{x}:#{y} was already occupied by rover #{plateau.grid[y - 1][x - 1]}. Houston is going to have a word with you mister!")
        plateau.grid[y - 1][x - 1] = -1
      else
        plateau.grid[y - 1][x - 1] = id
      end
    end

    def execute_instructions!
      instructions.each_char do |instruction|
        case instruction
        when 'M'
          move_forward!
          sleep 0.3 unless MarsRover.env.test?
          plateau.print_grid
        when 'L'
          turn_left!
        when 'R'
          turn_right!
        end

        break if invalid_position?
      end
    end

    def input_position_message
      message = "🧭 Provide the deployment position for rover #{id} consisting of the x-coordinate, y-coordinate and the cardinal compass point direction " \
                'the rover should be facing, separated by spaces. '
      message += 'Leave blank and hit enter if there are no more rovers to deploy. ' if id > 1
      message += '(Example: "1 2 N"): '
      message
    end

    def input_instructions_message
      "🗺  Provide a set of instructions for rover #{id} consisting of the letters \"L\" which spins the rover 90 degrees left, \"R\" which spins the rover " \
        '90 degrees right, and "M" which moves the rover one grid point forward and maintains the same heading. (Example: "MRMMRMLLMRM"): '
    end

    def last?
      id > 1 && position.blank?
    end

    def crashed?
      @errors.any?
    end

    private

    def move_forward!
      @last_known_coordinates = { x:, y: }
      plateau.grid[y - 1][x - 1] = nil

      case direction
      when 'N'
        @y += 1
      when 'E'
        @x += 1
      when 'S'
        @y -= 1
      when 'W'
        @x -= 1
      end

      validate_position_and_deploy!
    end

    def validate_position_and_deploy!
      validate_position

      if valid_position?
        deploy!
      else
        position_error!("#{x}:#{y} is not in range of our communication satellites. Uh, Houston, we've had a problem. We lost rover #{id}?!")
        plateau.grid[last_known_coordinates[:y] - 1][last_known_coordinates[:x] - 1] = -2
      end
    end

    def turn_left!
      @direction = CARDINAL_POINTS[CARDINAL_POINTS.index(direction) - 1]
    end

    def turn_right!
      @direction = CARDINAL_POINTS[CARDINAL_POINTS.index(direction) + 1] || 'N'
    end

    def position_error!(message)
      @errors.clear
      @errors << { position: message }
      @valid[:position] = false
    end

    def validate
      return true if last?

      @errors.clear
      validate_position if position && invalid_position?
      validate_instructions if instructions && invalid_instructions?
      errors.empty?
    end

    def validate_position
      @errors << { x: 'coordinate can not be blank' } if x.blank?
      @errors << { y: 'coordinate can not be blank' } if y.blank?
      @errors << { direction: 'can not be blank' } if direction.blank?
      @errors << { x: 'coordinate can not be greater than the plateau width' } if x.to_i > plateau.width
      @errors << { y: 'coordinate can not be greater than the plateau height' } if y.to_i > plateau.height
      @errors << { x: 'coordinate can not be negative or zero' } if x.to_i <= 0
      @errors << { y: 'coordinate can not be negative or zero' } if y.to_i <= 0
      @errors << { direction: 'should be one of N, E, S or W' } unless CARDINAL_POINTS.include?(direction)
      @valid[:position] = errors.empty?
      valid[:position]
    end

    def validate_instructions
      @errors << { instructions: 'can not be blank' } if instructions.blank?
      @errors << { instructions: 'should only include letters L, R and M' } if instructions.gsub(/[LRM]/, '').present?
      @valid[:instructions] = errors.empty?
      valid[:instructions]
    end

    def valid_position?
      valid[:position]
    end

    def invalid_position?
      !valid_position?
    end

    def valid_instructions?
      valid[:instructions]
    end

    def invalid_instructions?
      !valid_instructions?
    end
  end
end
