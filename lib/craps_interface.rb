module CrapsInterface

  def start_game
    while !@game_over
      @roll_sum=0
      break if cashout?
      reload
      break if @game_over
      come_out_bet
      next if come_out_roll
      bet_placement
      point_multiplier
      roll_after_come_out_roll
    end
  end

  def print_roll
    @dice.each do |die|
      a=die.roll
      print "[#{a}]  "
      @roll_sum+=a
    end
  end

  def buyin
    while true
      puts "What would you like to buyin for"
      reload=Money.new(gets.chomp.to_f*100, "USD")
      @buyin=@buyin+reload
      if !@buyin.zero?
        break
      end
    end
    @stack=@buyin
  end


  def cashout?
    puts "press y/yes to cashout, otherwise press enter to continue."
        answer=gets.chomp.downcase
        if answer=="y" ||answer== "yes"
          puts "Thank you come again, you bought in for $#{@buyin} and cashed out for $#{@stack}"
          return true
        end
  end

  def reload
    while @stack.zero?
      puts "Would you like to reload?"
      answer=gets.chomp
      if answer=="n" ||answer== "no"
        puts "Thank you come again, you bought in for $#{@buyin} and cashed out for $#{@stack}"
        @game_over=true
        break
      elsif answer=="y"||answer=="yes"
        puts "How much would you like to reload for"
        reload=Money.new(gets.chomp.to_f*100, "USD")
        if reload.zero?
          puts "I'm sorry could you try again"
          next
        end
        @stack+=reload
        @buyin+=reload
      else
        next
      end
    end
  end


  def come_out_roll
    puts "Thank you...now rolling...."
    print_roll
    if @roll_sum==7 ||@roll_sum==11
      @stack+=@wager
      puts "Congratulations you rolled  #{@roll_sum}, you win $#{@wager} and now have $#{@stack} "
      return true
    elsif @roll_sum<4 || @roll_sum==12
      @stack-=@wager
      puts "I'm sorry you rolled  #{@roll_sum} and crapped out, you now have $#{@stack}"
      return true
    end
    @point=@roll_sum
    puts "You have rolled  #{@roll_sum}, which is now your point."
  end

  def come_out_bet
    while true
      @cash_in_play=Money.new(0, "USD")
      puts "How much would you like to wager for the come out roll?"
      @wager=Money.new(gets.chomp.to_f*100, "USD")
      if @wager>@stack
        puts "I'm sorry, you only have $#{@stack}."
      next
      elsif @wager.zero?
        puts "I'm sorry you must place a wager to play"
        next
      else
        @cash_in_play+=@wager
        break
      end
    end
  end

  def bet_placement
    while true
      puts "Please place your bets behind the line"
      @bet_behind=Money.new(gets.chomp.to_f*100, "USD")
      if @bet_behind>(@stack-@wager)
        puts "You only have $#{@stack-@wager} to @wager."
        next
      else
        @cash_in_play+=@bet_behind
        break
      end
    end
  end

  def point_multiplier
    if @point==4||@point==10
      @multiplier=2
    elsif @point.odd?
      @multiplier=1.5
    else
      @multiplier=1.2
    end
  end

  def roll_after_come_out_roll
    while true
      @roll_sum=0
    puts "Thank you...now rolling...."
    print_roll
      if @roll_sum==7
        @stack=(@stack-@cash_in_play)
        puts "Oh no, you hit CRAPS! You lost $#{@cash_in_play}, and now have $#{@stack}"
        break
      elsif @roll_sum==@point
          @stack=(@stack+(@wager+@bet_behind*@multiplier))
          puts "You rolled #{@point}.  Congratulations you won #{(@wager+@bet_behind*@multiplier)} and now have $#{@stack}"
          break
      else
        puts "You rolled #{@roll_sum}. Please press enter to roll again"
        a=gets.chomp
      end
    end
  end


end
