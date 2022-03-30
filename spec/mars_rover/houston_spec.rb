# frozen_string_literal: true

RSpec.describe MarsRover::Houston do
  describe '.deploy_rovers' do
    context 'plateau' do
      let(:plateau_last_args) { ['1 1 N', 'M', ''] }

      it 'asks to provide dimensions for the grid' do
        allow($stdin).to receive(:gets).and_return('3 3', *plateau_last_args)
        expect { described_class.deploy_rovers }.to output(/Provide the width and height of the Mars plateau your rovers will land on/).to_stdout
      end

      it 'builds a grid when the dimensions are large enough' do
        allow($stdin).to receive(:gets).and_return('3 3', *plateau_last_args)
        expect { described_class.deploy_rovers }.to output(/---- ---- ----/).to_stdout
      end

      it 'does not allow a grid of one block only' do
        allow($stdin).to receive(:gets).and_return('1 1', '2 2', *plateau_last_args)
        expect { described_class.deploy_rovers }.to output(/Width must be greater than 1, Height must be greater than 1/).to_stdout
      end

      it 'does not allow negative numbers' do
        allow($stdin).to receive(:gets).and_return('-2 -2', '2 2', *plateau_last_args)
        expect { described_class.deploy_rovers }.to output(/Width must be greater than 1, Height must be greater than 1/).to_stdout
      end

      it 'does not allow blank numbers' do
        allow($stdin).to receive(:gets).and_return('', '2 2', *plateau_last_args)
        expect { described_class.deploy_rovers }.to output(/Width can not be blank, Height can not be blank/).to_stdout
      end

      it 'keeps on asking until valid dimensions are provided' do
        allow($stdin).to receive(:gets).and_return('', '1', '11', '1 1', '2 2', *plateau_last_args)
        expect { described_class.deploy_rovers }.to output(/Provide the deployment position for rover 1/).to_stdout
      end

      it 'builds a grid when eventually provided with valid dimensions' do
        allow($stdin).to receive(:gets).and_return('', '1', '11', '1 1', '-2 2', '2 2', *plateau_last_args)
        expect { described_class.deploy_rovers }.to output(/---- ----/).to_stdout
      end
    end

    context 'rover' do
      let(:plateau_args) { ['3 3'] }
      let(:rover_args) { ['1 1 E', 'M', ''] }

      describe 'position' do
        it 'asks to provide the position for the rover' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, *rover_args)
          expect { described_class.deploy_rovers }.to output(/Provide the deployment position for rover/).to_stdout
        end

        it 'deploys the rover with a valid position' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, *rover_args)
          expect { described_class.deploy_rovers }.to output(/\| 🚜 \|    \|    \|/).to_stdout
        end

        it 'does not allow negative coordinates' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '-1 1 N', *rover_args)
          expect { described_class.deploy_rovers }.to output(/X coordinate can not be negative or zero/).to_stdout
        end

        it 'does not allow coordinates that would land the rover outside of the plateau to the north' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '1 4 N', *rover_args)
          expect { described_class.deploy_rovers }.to output(/Y coordinate can not be greater than the plateau height/).to_stdout
        end

        it 'does not allow coordinates that would land the rover outside of the plateau to the east' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '4 1 N', *rover_args)
          expect { described_class.deploy_rovers }.to output(/X coordinate can not be greater than the plateau width/).to_stdout
        end

        it 'does not allow coordinates that would land the rover outside of the plateau to the south' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '1 -1 N', *rover_args)
          expect { described_class.deploy_rovers }.to output(/Y coordinate can not be negative or zero/).to_stdout
        end

        it 'does not allow coordinates that would land the rover outside of the plateau to the west' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '-1 1 N', *rover_args)
          expect { described_class.deploy_rovers }.to output(/X coordinate can not be negative or zero/).to_stdout
        end

        it 'does not allow empty coordinates' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '', *rover_args)
          expect { described_class.deploy_rovers }.to output(/X coordinate can not be blank/).to_stdout
        end
      end

      describe 'instructions' do
        it 'asks to provide instructions for the rover' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, *rover_args)
          expect { described_class.deploy_rovers }.to output(/Provide a set of instructions for rover/).to_stdout
        end

        it 'moves the rover with valid instructions' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, *rover_args)
          expect { described_class.deploy_rovers }.to output(/\|    \| 🚜 \|    \|/).to_stdout
        end

        it 'tells us when we lost a rover' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '1 1 N', 'MMM', '')
          expect { described_class.deploy_rovers }.to output(/Uh, Houston, we've had a problem. We lost rover 1/).to_stdout
        end

        it 'tells us when we lost a rover and ignores the remainder of the instructions' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '1 1 N', 'MMMMMMMMMMM', '')
          expect { described_class.deploy_rovers }.to output(/Uh, Houston, we've had a problem. We lost rover 1/).to_stdout
        end

        it 'shows us when we lost a rover to the north' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '1 1 N', 'MMM', '')
          expect { described_class.deploy_rovers }.to output(/\| 🪦 \|    \|    \|/).to_stdout
        end

        it 'shows us when we lost a rover to the east' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '1 1 N', 'RMMM', '')
          expect { described_class.deploy_rovers }.to output(/\|    \|    \| 🪦 \|/).to_stdout
        end

        it 'shows us when we lost a rover to the south' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '1 3 N', 'RRMMM', '')
          expect { described_class.deploy_rovers }.to output(/\| 🪦 \|    \|    \|/).to_stdout
        end

        it 'shows us when we lost a rover to the west' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '3 1 N', 'LMMM', '')
          expect { described_class.deploy_rovers }.to output(/\| 🪦 \|    \|    \|/).to_stdout
        end

        it 'tells us when we crashed into another rover' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '1 1 N', 'MM', '1 1 N', 'MM', '')
          expect { described_class.deploy_rovers }.to output(/Position 1:3 was already occupied by rover 1/).to_stdout
        end

        it 'tells us when we crashed into another rover and ignores the remainder of the instructions' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '1 1 N', 'MM', '1 1 N', 'MMMMMMMMMMMM', '')
          expect { described_class.deploy_rovers }.to output(/Position 1:3 was already occupied by rover 1/).to_stdout
        end

        it 'shows us when crashed into another rover' do
          allow($stdin).to receive(:gets).and_return(*plateau_args, '1 1 N', 'MM', '1 1 N', 'MM', '')
          expect { described_class.deploy_rovers }.to output(/\| 💥 \|    \|    \|/).to_stdout
        end
      end
    end
  end
end
