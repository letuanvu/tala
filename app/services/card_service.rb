class CardService
  def build_data
    card_types = ['R','C','B','T']
    card_types.each do |card_type|
      card_numbers = ['1','2','3','4','5','6','7','8','9','10','11','12','13']
      card_numbers.each do |card_number|
        puts "build card #{card_number}#{card_type}"
        card = Card.where(:card_type => card_type, :card_number => card_number).first
        if card.blank?
          card = Card.new
          card.card_type = card_type
          card.card_number = card_number
          card.save
        end
      end
    end
    slots = ['1','2','3','4']
    slots.each do |slot|
      puts "build player #{slot}"
      player = Player.where(:player_name => "Player #{slot}", :player_slot => slot).first
      if player.blank?
        player = Player.new
        player.player_name = "Player #{slot}"
        player.player_slot = slot
        player.save
      end
    end
  end

  def card_type_to_icon str
    str = str.gsub("R", "♦")
    str = str.gsub("C", "♥")
    str = str.gsub("B", "♠")
    str = str.gsub("T", "♣")
  end

  def new_match

    CardStorage.delete_all
    PlayerCard.delete_all
    Option.where(:option_name => 'last_player_card_showing_id').delete_all

    cards = []
    Card.all.each do |card|
      cards << "#{card.card_number}.#{card.card_type}"
    end
    player_1_cards = cards.sample(10)
    player = Player.where(:player_slot => 1).first
    player.player_cards = player_1_cards.to_json
    player.save
    player_1_cards.each do |card|
      card_info = card.split('.')
      pc = PlayerCard.new
      pc.player_slot = 1
      pc.card_number = card_info[0]
      pc.card_type = card_info[1]
      pc.is_showing = false
      pc.save
    end
    cards = cards - player_1_cards

    player_2_cards = cards.sample(9)
    player = Player.where(:player_slot => 2).first
    player.player_cards = player_1_cards.to_json
    player.save
    player_2_cards.each do |card|
      card_info = card.split('.')
      pc = PlayerCard.new
      pc.player_slot = 2
      pc.card_number = card_info[0]
      pc.card_type = card_info[1]
      pc.is_showing = false
      pc.save
    end
    cards = cards - player_2_cards

    player_3_cards = cards.sample(9)
    player = Player.where(:player_slot => 3).first
    player.player_cards = player_1_cards.to_json
    player.save
    player_3_cards.each do |card|
      card_info = card.split('.')
      pc = PlayerCard.new
      pc.player_slot = 3
      pc.card_number = card_info[0]
      pc.card_type = card_info[1]
      pc.is_showing = false
      pc.save
    end
    cards = cards - player_3_cards

    player_4_cards = cards.sample(9)
    player = Player.where(:player_slot => 4).first
    player.player_cards = player_1_cards.to_json
    player.save
    player_4_cards.each do |card|
      card_info = card.split('.')
      pc = PlayerCard.new
      pc.player_slot = 4
      pc.card_number = card_info[0]
      pc.card_type = card_info[1]
      pc.is_showing = false
      pc.save
    end
    cards = cards - player_4_cards

    cards.each do |card|
      card_info = card.split('.')
      pc = CardStorage.new
      pc.card_number = card_info[0]
      pc.card_type = card_info[1]
      pc.save
    end

    o = Option.where(:option_name => 'slot_turn').first
    if o.blank?
      o = Option.new
      o.option_name = 'slot_turn'
    end
    o.option_value = 1
    o.save



  end

  def caculation_card_group player_slot
    card_groups = []
    not_in = []
    cards = PlayerCard.where(:player_slot => player_slot).all
    cards.all.each do |card|
      card_type = card.card_type
      card_number = card.card_number

      puts "checking #{card_number}.#{card_type}".green

      # group by type
      less = card.card_number.to_i - 1
      greater = card.card_number.to_i + 1
      card_less = PlayerCard.where.not(:id => not_in).where(:player_slot => player_slot, :card_type => card_type, :card_number => less).all.as_json
      card_greater = PlayerCard.where.not(:id => not_in).where(:player_slot => player_slot, :card_type => card_type, :card_number => greater).all.as_json
      relation_count = card_less.size + card_greater.size
      if relation_count >= 2
        relation_cards = card_less + [card.as_json] + card_greater
        relation_cards.each do |relation_card|
          not_in << relation_card['id']
        end
        card_groups << relation_cards
      end

      # group by number
      group_by_number = PlayerCard.where.not(:id => not_in).where(:player_slot => player_slot, :card_number => card_number).where.not(:id => card.id).all.as_json
      if group_by_number.size >= 2
        relation_cards = group_by_number + [card.as_json]
        relation_cards.each do |relation_card|
          not_in << relation_card['id']
        end
        card_groups << relation_cards
      end

    end
    return card_groups
  end

  def play
    o = Option.where(:option_name => 'slot_turn').first
    player_slot = o.option_value

    card_group = caculation_card_group(player_slot)
    if card_group.size >= 3
      # win cmnr
      puts "player #{player_slot} win !".green
      return
    end

    o = Option.where(:option_name => 'last_player_card_showing_id').first
    if o.present?
      last_player_card_showing_id = o.option_value
      last_player_card_showing = PlayerCard.where(:id => last_player_card_showing_id).first
      old_player_slot = last_player_card_showing.player_slot

      # try add this cart for this player
      last_player_card_showing.player_slot = player_slot
      last_player_card_showing.save

      # re caculation_card_group
      card_group_ids = []
      card_groups = caculation_card_group(player_slot)
      card_groups.each do |card_group|
        card_group.each do |card|
          card_group_ids << card['id']
        end
      end

      # if this card can join to card_group
      if card_group_ids.include?(last_player_card_showing_id)

      else
        # return to old player
        last_player_card_showing.player_slot = old_player_slot
        last_player_card_showing.save

        # add new card from card storage
        get_new_card(player_slot)
      end

    end

    # showing a card
    showing_card(player_slot)

  end

  def get_new_card player_slot
    new_card = CardStorage.order("RANDOM()").limit(1)
    pc = PlayerCard.new
    pc.player_slot = player_slot
    pc.card_number = new_card.card_number
    pc.card_type = new_card.card_type
    pc.is_showing = false
    pc.save
  end

  def showing_card player_slot

  end

end
