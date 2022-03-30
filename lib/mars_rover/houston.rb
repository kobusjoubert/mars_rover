# frozen_string_literal: true

module MarsRover
  class Houston
    class << self
      def deploy_rovers
        print welcome_message
        plateau = Plateau.new
        build_plateau(plateau)
        id = 0

        loop do
          id += 1
          rover = Rover.new(id:, plateau:)
          rover_position(rover)
          break if rover.last?

          rover_instructions(rover)
        rescue MarsRover::CrashError
          break
        end
      end

      private

      def build_plateau(plateau)
        print plateau.input_message
        plateau.grid_size = $stdin.gets

        while plateau.invalid?
          puts plateau.error_messages
          print plateau.input_message
          plateau.grid_size = $stdin.gets
        end

        plateau.build_grid!
        plateau.print_grid
      end

      def rover_position(rover)
        print rover.input_position_message
        rover.position = $stdin.gets

        while rover.invalid?
          puts rover.error_messages
          print rover.input_position_message
          rover.position = $stdin.gets
        end

        return if rover.last?

        deploy_rover(rover)
      end

      def rover_instructions(rover)
        print rover.input_instructions_message
        rover.instructions = $stdin.gets

        while rover.invalid?
          puts rover.error_messages
          print rover.input_instructions_message
          rover.instructions = $stdin.gets
        end

        execute_rover_instructions(rover)
      end

      # TODO: Refactor.
      def deploy_rover(rover)
        rover.deploy!
        rover.plateau.print_grid
        return unless rover.crashed?

        puts rover.error_messages
        raise MarsRover::CrashError
      end

      # TODO: Refactor.
      def execute_rover_instructions(rover)
        rover.execute_instructions!
        rover.plateau.print_grid
        return unless rover.crashed?

        puts rover.error_messages
        raise MarsRover::CrashError
      end

      def welcome_message
        $stdout.clear_screen unless MarsRover.env.test?
        <<-WELCOM_MESSAGE

          \e[37m
                                            ▄▄▄▄▄▄▄▄▄▄▄▄▄
                                            ▓█      ▒  ▐█▌
                                            ▓█    ▐███ ▐█▌
                                            ▓█      ▀  ▐█▌
                                            ▀▀▀▀▀▀██▀▀▀▀▀
                                                  █▌
                        ▄▄▄▄▄▄▄▄                  █▌                    ▄███▀
                       ██▀▀▀▀▀▀▀▀██▄              █▌                    ██
                       ██          ▀██▄           █▌                 ▄██▀▀██▀
                       ████████████████████████████████████▌    ▄█████
                         ▐█                   ▄▄▄▄▄▄▄▄▄▄  ███████  ▐█▌
                         ▐█     ▄         ▄          ▄    █▌    ████▀
                         ▐█▄▄██▀▀▀█▄▄▄▄▓█▀▀▀██▄▄▄▄██▀▀▀█▄▄█▌
                          ▀▀█▌▐██▌ ██▀██ ▓██ ▓█▀██▌▐██▄▐██▀
                            ██ ▀▀ ▄█▌ ▐█▄ ▀ ▄██  ██ ▀▀ ██
                             ▀▀███▀     ▀███▀▀    ▀▀██▀▀

          \e[31m
          ███    ███  █████  ██████  ███████     ██████   ██████  ██    ██ ███████ ██████
          ████  ████ ██   ██ ██   ██ ██          ██   ██ ██    ██ ██    ██ ██      ██   ██
          ██ ████ ██ ███████ ██████  ███████     ██████  ██    ██ ██    ██ █████   ██████
          ██  ██  ██ ██   ██ ██   ██      ██     ██   ██ ██    ██  ██  ██  ██      ██   ██
          ██      ██ ██   ██ ██   ██ ███████     ██   ██  ██████    ████   ███████ ██   ██
          \e[0m

        WELCOM_MESSAGE
      end
    end
  end
end
