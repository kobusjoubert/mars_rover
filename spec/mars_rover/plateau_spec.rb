# frozen_string_literal: true

RSpec.describe MarsRover::Plateau do
  let(:plateau) { described_class.new }

  describe '#grid_size=' do
    it 'sets the width' do
      plateau.grid_size = '4 3'
      expect(plateau.width).to eq(4)
    end

    it 'sets the height' do
      plateau.grid_size = '4 3'
      expect(plateau.height).to eq(3)
    end

    it 'sets the plateau to invalid when no height supplied' do
      plateau.grid_size = '4'
      expect(plateau.valid?).to be false
    end

    it 'sets the plateau to invalid when no width supplied' do
      plateau.grid_size = ''
      expect(plateau.valid?).to be false
    end

    it 'sets the plateau to invalid when the width is too small' do
      plateau.grid_size = '1 3'
      expect(plateau.valid?).to be false
    end

    it 'sets the plateau to invalid when the height is too small' do
      plateau.grid_size = '3 1'
      expect(plateau.valid?).to be false
    end

    it 'sets the plateau to valid when the height and width is large enough' do
      plateau.grid_size = '2 2'
      expect(plateau.valid?).to be true
    end
  end

  describe '#build_grid!' do
    let(:empty_grid) { [[nil, nil, nil], [nil, nil, nil]] }

    before(:each) do
      plateau.grid_size = '3 2'
    end

    it 'sets the grid' do
      plateau.build_grid!
      expect(plateau.grid).to eq(empty_grid)
    end
  end
end
