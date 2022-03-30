# MarsRover

![mars_rover_animation](https://user-images.githubusercontent.com/3071529/160900980-c1fd8e1c-25a6-4df5-94fe-453c9e7433b5.gif)

[Mars Rover Technical Challenge](https://code.google.com/archive/p/marsrovertechchallenge/)

A squad of robotic rovers are to be landed by NASA on a plateau on Mars.

This plateau, which is curiously rectangular, must be navigated by the rovers so that their on board cameras can get a complete view of the surrounding terrain to send back to Earth.

A rover's position is represented by a combination of an x and y co-ordinates and a letter representing one of the four cardinal compass points. The plateau is divided up into a grid to simplify navigation. An example position might be 0, 0, N, which means the rover is in the bottom left corner and facing North.

In order to control a rover, NASA sends a simple string of letters. The possible letters are 'L', 'R' and 'M'. 'L' and 'R' makes the rover spin 90 degrees left or right respectively, without moving from its current spot.

'M' means move forward one grid point, and maintain the same heading.

Assume that the square directly North from (x, y) is (x, y+1).

## Assumptions

The Mars plateau will not be larger than the terminal's screen for display purposes.

A rover has to get to its destination before another rover can be landed and start its journey.

You have a working Ruby environment.

## Installation

Clone the repository.

    git clone https://github.com/kobusjoubert/mars_rover.git

Change into the project directory

    cd mars_rover

Install dependencies.

    bin/setup

## Usage

Deploy rovers to Mars.

    bundle exec exe/mars_rover

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests and `rake rubocop` to check styling. You can also run `MARS_ROVER_ENV=development bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kobusjoubert/mars_rover.

## License

The project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
