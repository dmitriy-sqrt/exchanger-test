# frozen_string_literal: true

require 'rspec'
require_relative '../storage'
require_relative '../exchanger'

# rubocop:disable Metrics/BlockLength
RSpec.describe Exchanger do
  let(:storage) { Storage.new(storage_values) }
  subject { described_class.new(storage: storage) }

  context 'with initial storage filled correctly' do
    let(:storage_values) do
      {
        50 => 2,
        25 => 8,
        10 => 14,
        5 => 11,
        2 => 3,
        1 => 1
      }
    end

    it 'gives correct exchanges while storage is capable' do
      expect(subject.give_change(bill: 2)).to match_array(
        [50, 50, 25, 25, 25, 25]
      )

      expect(subject.give_change(bill: 2)).to match_array(
        [25, 25, 25, 25, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
      )

      expect(subject.give_change(bill: 1)).to match_array(
        [10, 10, 10, 10, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 2, 2, 1]
      )

      expect { subject.give_change(bill: 1) }
        .to raise_error(Exchanger::NotEnoughMoneyError)
    end
  end

  context 'with initial storage enough but coins set not suitable' do
    let(:storage_values) do
      {
        50 => 1,
        25 => 1,
        10 => 2,
        5 => 0,
        2 => 3,
        1 => 0
      }
    end

    it 'raises error' do
      expect { subject.give_change(bill: 1) }
        .to raise_error('Exchanger::NotEnoughMoneyError')
    end
  end
end
# rubocop:enable Metrics/BlockLength
