#!/usr/bin/env ruby
require "yaml"



#cheat sheet e-t-a-i-o-n-s-r-l-u-d-g
#TODO List
#read in file dictionary method
#separate the words and store them in an array ^same method
#redact them until correct letter is guessed check answer method
#find the positions of the matched letters and display them but keep the dashes for the unsolved lettered.
#create a method called select letter
#create a method called check win condition
#create a method called display
#
#
#
#
#

class Hangman
   
  def initialize
    
    @save_or_load=[]
    @missed_letters=[]
    @who_wins=[]
    @dictionary=[]
    @redacted=[]
    @lines = File.readlines "../5desk.txt"
    @text = @lines.join
    @all_words = @text.scan(/\w+/)
    
    @all_words.each_with_index do |words,index|
      if index.between?(197,396) && words.length.between?(5,13)
        @dictionary << words.downcase
      end
    end
    
    @selected_word=@dictionary[rand(88)]
    @turns=6
    
    0.upto(@selected_word.length-1) do
      @redacted << "- "
    end
   
    @display=@redacted
    @letter_entered=[]
    @game_state=[]
  end
   
    def display_update
      #$display=$readacted if $display[-1]==nil
      puts @display.join
      
      
      0.upto(@selected_word.length-1) do |x|
       if @selected_word[x].to_s==@letter_entered[-1].to_s        
         @display[x]=@letter_entered[-1]
       end
      end

   
     puts "correct guess" if @selected_word.include?("#{@letter_entered[-1]}") && @letter!=@redacted
     puts "incorrect guess" if !@selected_word.include?("#{@letter_entered[-1]}")
     @missed_letters << @letter_entered[-1] if !@selected_word.include?("#{@letter_entered[-1]}")
     puts @display.join
    end
    
    def player_select
      puts "enter a letter or the number 1 to save the game"
            checker_var='0'
        while((checker_var=='0' && !checker_var.between?('a','z')) && checker_var!='1')
          checker_var = gets.chomp 
          @letter_entered << checker_var if checker_var.between?('a','z')
          @save_or_load << checker_var if checker_var=='1' || checker_var=='2'
        end
        saveGame if @save_or_load[-1]=='1' 
        #loadGame if $save_or_load[-1]=='2'
    end
    
    def check_winning_condition
      if @display.join==@selected_word
        puts true
        @who_wins = "You win"
      elsif @display.join==@selected_word && @turns==0
        @who_wins = "You win"
      elsif @display.join!=@selected_word && @turns==0
        @who_wins = "You lose"
      end
    end
    
    def end_of_turn
      @turns-=1
      puts "You have #{@turns} guesses left"
    end
    
    def play_Hangman
        if(File.exist?("saved.yaml"))
         until(@save_or_load[-1]=='2' || @save_or_load[-1]=='3')
          puts  "load saved game?"
          puts  "2 for yes and 3 for no"
          @save_or_load << gets.chomp
          puts @save_or_load==2
         end
        end
        
        loadGame if @save_or_load[-1]=='2'
        @save_or_load=[]
       puts "can you guess the correct word in #{@turns} guesses"
       puts
       puts @redacted.join
       puts
       until(@who_wins=="You win" || @who_wins=="You lose")
        player_select
        break if @save_or_load[-1]=='1' || @save_or_load[-1]=='2'
        puts
        display_update
        end_of_turn if !@selected_word.include?("#{@letter_entered[-1]}") && @letter!=@redacted 
        puts
        check_winning_condition
        puts
       end
       puts "you lose the word is #{@selected_word}" if @who_wins=="You lose"
       puts "You win!" if @who_wins=="You win"
    end
    
    def saveGame(fname = "saved.yaml")
      @game_state=[@selected_word,@redacted,@letter_entered,@missed_letters,@turns]
      yaml = YAML::dump(@game_state)
      File.open(fname, "w") do |f|
      f.puts yaml
    end
      puts yaml
      puts "** Game saved.\n"
    end
    
   def loadGame(fname = "saved.yaml")
    fd = File.open(fname)
    yaml = fd.read()
    fd.close
   @game_state = YAML::load(yaml)
    puts "\n** Game loaded.\n"
    @selected_word=@game_state[0]
     @redacted=@game_state[1]
     @letter_entered=@game_state[2]
     @missed_letters=@game_state[3]
     @turns=@game_state[4]
     @display=@redacted
    # $turns+=1
   end
   
    
  #  puts "can you guess the correct word"
  #while ($who_wins==nil)
    
  #  puts $display.join
  #  puts "You have #{$turns-=1} guesses left" 
  #end
    #puts $game_state[1][0]
    
    
    
       
    
    
    
end

h = Hangman.new
h.play_Hangman
puts
puts "press any key to end"
any_key=gets.chomp