# frozen_string_literal: true

RSpec.describe Rapporteur::CheckList, type: :model do
  let(:list) { described_class.new }

  context '#add' do
    it 'adds the given object to the list' do
      list.add(check = double)
      expect(list.to_a).to include(check)
    end

    it 'does not return duplicate entries' do
      list.add(check = double)
      list.add(check)
      expect(list.to_a).to have(1).check
    end
  end

  context '#clear' do
    it 'empties the list of objects' do
      list.add(double)
      expect { list.clear }.to change(list, :empty?).to(true)
    end
  end

  context '#each' do
    it 'yields each contained object in the order added' do
      list.add(check0 = double)
      list.add(check1 = double)
      list.add(check2 = double)
      returns = []

      list.each do |object|
        returns << object
      end

      expect(returns[0]).to equal(check0)
      expect(returns[1]).to equal(check1)
      expect(returns[2]).to equal(check2)
    end

    it 'returns itself' do
      expect(list.each).to equal(list)
    end
  end

  context '#to_a' do
    it 'returns an Array' do
      expect(list.to_a).to be_an(Array)
    end

    it 'returns new different but equivalent Array instances' do
      return1 = list.to_a
      return2 = list.to_a
      expect(return1).to_not equal(return2)
      expect(return1).to eq(return2)
    end
  end
end
