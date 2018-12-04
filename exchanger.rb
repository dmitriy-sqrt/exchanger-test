# frozen_string_literal: true

# Provides coins exchange for bill nominal if enough coins are in stock
class Exchanger
  class NotEnoughMoneyError < StandardError; end

  def initialize(storage:)
    @storage = storage
  end

  def give_change(bill:)
    @backup_storage = @storage
    amount = bill * 100
    choose_coins(amount)
  rescue NotEnoughMoneyError
    @storage = @backup_storage
    raise NotEnoughMoneyError
  end

  private

  def choose_coins(sum_remaining)
    coins_given = []

    loop do
      next_coin = choose_next_coin(sum_remaining) || raise(NotEnoughMoneyError)

      sum_remaining -= next_coin
      @storage.withdraw_coin(next_coin)
      coins_given << next_coin

      break if sum_remaining.zero?
    end

    coins_given
  end

  def choose_next_coin(sum_remaining)
    Storage::COINS.find do |coin|
      (coin <= sum_remaining) && @storage.coin_in_stock?(coin)
    end
  end
end
