require 'money'

class Die
	def roll 
		1+rand(6)
	end

end


past=[]
point=0
craps=false
buyin=Money.new(0, "USD")
stack=Money.new(0, "USD")
dice=[Die.new, Die.new]
roll_sum=0

print_roll= Proc.new do
	dice.each do |die|
		a=die.roll
		print "[#{a}]  "
		roll_sum+=a
	end
end

while true
	puts "What would you like to buyin for"
	reload=Money.new(gets.chomp.to_f*100, "USD")
	buyin=buyin+reload
	if !buyin.zero?
		break
	end
end
stack=buyin
while !craps
	roll_sum=0
		puts "press y/yes to cashout, otherwise press enter to continue."
		answer=gets.chomp.downcase
		if answer=="y" ||answer== "yes"
			puts "Thank you come again, you bought in for $#{buyin} and cashed out for $#{stack}"
			break
		end
	while true
		if stack.zero?
			puts "Would you like to reload?"
			answer=gets.chomp
			if answer=="n" ||answer== "no"
				puts "Thank you come again, you bought in for $#{buyin} and cashed out for $#{stack}"
				craps=true
				break
			elsif answer=="y"||answer=="yes"
				puts "How much would you like to reload for"
				reload=Money.new(gets.chomp.to_f*100, "USD")
				if reload.zero?
					puts "I'm sorry could you try again"
					next
				end
				stack+=reload
				buyin+=reload
			else
				next
			end
		end
		cash_in_play=Money.new(0, "USD")
		puts "How much would you like to wager for the come out roll?"
		wager=Money.new(gets.chomp.to_f*100, "USD")
		if wager>stack
			puts "I'm sorry, you only have $#{stack}."
		next
		elsif wager.zero?
			puts "I'm sorry you must place a wager to play"
			next
		else
			cash_in_play+=wager
			break
		end
	end
	if craps
		break 
	end
	puts "Thank you...now rolling...."
	print_roll.call
	if roll_sum==7 ||roll_sum==11
		stack+=wager
		puts "Congratulations you rolled  #{roll_sum}, you win $#{wager} and now have $#{stack} "
		next
	elsif roll_sum<4 || roll_sum==12
		stack-=wager
		puts "I'm sorry you rolled  #{roll_sum} and crapped out, you now have $#{stack}"
		next
	end
	point=roll_sum
	puts "You have rolled  #{roll_sum}, which is now your point."
	while true
		puts "Please place your bets behind the line"
		bet_behind=Money.new(gets.chomp.to_f*100, "USD")
		if bet_behind>(stack-wager)
			puts "You only have $#{stack-wager} to wager."
			next
		else
			cash_in_play+=bet_behind
			break
		end
	end
	if point==4||point==10
		multiplier=2
	elsif point.odd?
		multiplier=1.5
	else
		multiplier=1.2
	end

	while true
		roll_sum=0
	puts "Thank you...now rolling...."
	print_roll.call
		if roll_sum==7
			stack=(stack-cash_in_play)
			puts "Oh no, you hit CRAPS! You lost $#{cash_in_play}, and now have $#{stack}"
			break
		elsif roll_sum==point
				stack=(stack+(wager+bet_behind*multiplier))
				puts "You rolled #{point}.  Congratulations you won #{(wager+bet_behind*multiplier)} and now have $#{stack}"
				break
		else
			puts "You rolled #{roll_sum}. Please press enter to roll again"
			a=gets.chomp 		
		end
	end
end




