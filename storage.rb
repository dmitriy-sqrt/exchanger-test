# frozen_string_literal: true

# more of a storage interface for the exchanger
# @TODO: implement checks for supported values && max/mins amounts
# before going to production
class Storage
  # can be sorted to change coin priorities
  COINS = [50, 25, 10, 5, 2, 1].freeze

  def initialize(storage = {})
    @storage = storage
  end

  def coin_in_stock?(coin)
    @storage[coin].positive?
  end

  def withdraw_coin(coin)
    @storage[coin] -= 1
  end
end
