# frozen_string_literal: true

module MarsRover
  class Plateau < Base
    attr_reader :grid, :width, :height

    def initialize
      super
      @grid = []
    end

    def grid_size=(value)
      @width, @height = value.chomp.split.compact_blank
      @width = width.presence&.to_i
      @height = height.presence&.to_i
    end

    # A grid made up of a two-dimensional array holding arrays of rows. The numbers represent the rovers' IDs on the grid.
    #
    # === Example
    #
    #   [[nil, nil, 1, nil], [2, nil, nil, nil], [nil, nil, 3, nil]]
    #
    # (y)
    #     --- --- --- ---
    #  2 |   |   | 3 |   |
    #     --- --- --- ---
    #  1 | 2 |   |   |   |
    #     --- --- --- ---
    #  0 |   |   | 1 |   |
    #     --- --- --- ---
    #      0   1   2   3  (x)
    #
    def build_grid!
      @grid = Array.new(height) { Array.new(width) }
    end

    def print_grid
      $stdout.clear_screen unless MarsRover.env.test?
      puts "\n\e[33m"

      grid.reverse.each do |row|
        puts ' ----' * width

        row.each do |column|
          print_point(column)
        end

        puts '|'
      end

      puts ' ----' * width
      puts "\n\e[0m"
    end

    def input_message
      '📐 Provide the width and height of the Mars plateau your rovers will land on. (Example: "10 7"): '
    end

    private

    def print_point(column)
      unless column
        print '|    '
        return
      end

      icon =
        if column.positive?
          MarsRover::Rover::ROVER_MODELS[(column - 1) % MarsRover::Rover::ROVER_MODELS.count]
        else
          MarsRover::Rover::ROVER_ERRORS[column.abs - 1]
        end

      print "| #{icon} "
    end

    def validate
      @errors = []
      @errors << { width: 'can not be blank' } if width.blank?
      @errors << { height: 'can not be blank' } if height.blank?
      @errors << { width: 'must be greater than 1' } if width.to_i <= 1
      @errors << { height: 'must be greater than 1' } if height.to_i <= 1
      errors.empty?
    end
  end
end
