# frozen_string_literal: true

RSpec.describe MarsRover::Rover do
  let(:plateau) { MarsRover::Plateau.new }

  before(:each) do
    plateau.grid_size = '3 3'
  end

  let(:rover) { described_class.new(id: 1, plateau:) }

  describe '#position=' do
    it 'sets the position' do
      rover.position = '1 2 N'
      expect(rover.position).to eq('1 2 N')
    end

    it 'sets the position even when too much white space' do
      rover.position = '  1   2   N  '
      expect(rover.position).to eq('1 2 N')
    end

    it 'sets the x coordinate' do
      rover.position = '1 2 N'
      expect(rover.x).to eq(1)
    end

    it 'sets the y coordinate' do
      rover.position = '1 2 N'
      expect(rover.y).to eq(2)
    end

    it 'sets the direction' do
      rover.position = '1 2 N'
      expect(rover.direction).to eq('N')
    end

    it 'converts the direction to uppercase' do
      rover.position = '1 2 n'
      expect(rover.direction).to eq('N')
    end

    it 'sets the rover to invalid when no position supplied' do
      rover.position = ''
      expect(rover.valid?).to be false
    end

    it 'sets the rover to invalid when no x and y coordinates supplied' do
      rover.position = 'N'
      expect(rover.valid?).to be false
    end

    it 'sets the rover to invalid when no direction supplied' do
      rover.position = '1 2'
      expect(rover.valid?).to be false
    end

    it 'sets the rover to valid when the x and y coordinates and the directions are supplied' do
      rover.position = '1 2 N'
      expect(rover.valid?).to be true
    end
  end

  describe '#instructions=' do
    it 'sets the instructions' do
      rover.instructions = 'MM'
      expect(rover.instructions).to eq('MM')
    end

    it 'sets the instructions even when too much white space' do
      rover.instructions = '  M  L  M  R M '
      expect(rover.instructions).to eq('MLMRM')
    end

    it 'converts the instrucsion to uppercase letters' do
      rover.instructions = 'MmLMrRLmM'
      expect(rover.instructions).to eq('MMLMRRLMM')
    end

    it 'sets the rover to invalid when incorrect instructions supplied' do
      rover.instructions = 'MI3'
      expect(rover.valid?).to be false
    end
  end
end
