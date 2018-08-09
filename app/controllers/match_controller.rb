class MatchController < ApplicationController
  def new_match

    if params[:play].present?
      puts "playing".yellow
      CardService.new.play
    else
      puts "new_match".yellow
      CardService.new.new_match
    end

    @player_cards = []
    @player_card_groups = []

    @player_cards[1] = PlayerCard.where(:player_slot => 1, :is_showing => false).order('card_type, card_number').all
    @player_card_groups[1] = CardService.new.caculation_card_group 1

    @player_cards[2] = PlayerCard.where(:player_slot => 2, :is_showing => false).order('card_type, card_number').all
    @player_card_groups[2] = CardService.new.caculation_card_group 2

    @player_cards[3] = PlayerCard.where(:player_slot => 3, :is_showing => false).order('card_type, card_number').all
    @player_card_groups[3] = CardService.new.caculation_card_group 3

    @player_cards[4] = PlayerCard.where(:player_slot => 4, :is_showing => false).order('card_type, card_number').all
    @player_card_groups[4] = CardService.new.caculation_card_group 4

    @card_storage = CardStorage.all
  end
end
