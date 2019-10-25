require 'tty-prompt' # require for fancy prompting (replaces switch case)
require 'tty-font' # require for special title fonts
require 'pastel' # require for coloring text

class TownHallBrawl
    $prompt = TTY::Prompt.new # create new prompt object 
    $font = TTY::Font.new(:doom) # create a new font object
    $sounds_array = []
    attr_accessor :difficulty, :tokens, :score, :gamesLeftToPlay, :points # accessors for game attributes

    # initiatize a game with some starting values (game starts at difficulty 1)
    def initialize(tokens = 4, points = 0, difficulty = 1, gamesLeftToPlay = 5, score = 0)
        @tokens = tokens
        @points = points
        @score = score
        @difficulty = difficulty
        @gamesLeftToPlay = gamesLeftToPlay

        populateTownHall(10)
    end
    
    $final_array = [] # holds the initiatives that will be pulled from
    $difficulty_level = ["Civil", "Tense", "Uncomfortable", "Hostile", "Badarse"] # names of difficulties
    $max_tokens = 4 # max amount of tokens for a specific difficulty
    MAX_ROUNDS = 5 # max number of rounds per match

    # this method uses tty-prompt to create a single option way to force a user to navigate uni-directionally in the application
    def userSingleOption(question, option)
        $prompt.select(question, [option]) # takes a statement/question and a predefined option name (that is returned)
    end

    # this method gets text input from the user and returns it
    def getUserInput
        print "Enter your input: "
        gets.chomp # return user input
    end

    # this method starts the game up
    def gameStartup
        gameIntro # introduces the game with some fun text
        gameMenuSelection # navigates to the game menu selection
    end

    # this method prints out an intro message
    def gameIntro
        system("clear")
        print_sleep("Our esteemed mayor, ", 1)
        print_sleep("#{ColorizedString.new(Faker::FunnyName.name).green} of ", 2)
        print_sleep("#{ColorizedString.new(Faker::Restaurant.name).green} Town has called for a #{ColorizedString.new("town hall meeting").green}!\n", 3)
        puts_sleep("", 2)

        print_sleep("You know what that means? \n", 2)
        print_sleep(ColorizedString.new("It's ").red, 1)
        print_sleep(ColorizedString.new("time ").red, 1)
        print_sleep(ColorizedString.new("for\n\n").red, 1)

        pastel = Pastel.new

        system("clear")

        print pastel.red($font.write("TOWN "))
        puts ""
        print pastel.red($font.write("HALL "))
        puts ""
        print pastel.red($font.write("BRAWL"))

    end

    # this method provides a prompt that determines if the player wants to play or not
    def gameMenuSelection

        menuSelection = $prompt.select(ColorizedString.new("\n\nWould you like to Play Town Hall Brawl?").red, 
                                                                        ['Yes, I would!', 'NO! Be gone you fiend!']) # menu selection
        case menuSelection #handling the responses from the prompt
        when 'Yes, I would!' # if user selected the YES option
            startGameMenu # go to the game menu
        when 'NO! Be gone you fiend!' # if user selected the NO option
            endGame # end the game
        end
    end

    # this method provides the options during a single game (round)
    def startGameMenu 
        system("clear") # clear all previous console text and put some round-information to the console
        puts ColorizedString.new("Current Game Menu").blue
        puts "---------------------------------------------------------"
        puts "#{gamesLeftToPlay} #{ColorizedString.new("games left until end of match").light_blue}"
        puts "#{ColorizedString.new("You have").light_blue} #{self.tokens} tokens #{ColorizedString.new("left.").light_blue}\n\n"

        # prompt the user
        menuSelection = menuSelection = $prompt.select(ColorizedString.new("What would you like to do?").red, ['Game Overview (Read Before Playing!)', 'Change Difficulty',
                                                                                'View Citizens', 'Edit Room', "Start Brawl", 'End Game'])

        case menuSelection # handle user response
        when 'Game Overview (Read Before Playing!)' # if they choose to read game overview
            startGameReadOverview # 
        when 'Change Difficulty' # if they want to change the difficulty
            startGameChangeDifficulty
        when 'View Citizens' # if they want to see the citizen list in the current round
            startGameViewParticipants
        when 'Edit Room' # if they want to make edits (use tokens) to modify the room
            startGameHedgeBetsMenu
        when 'Start Brawl' # if they want to begin the Brawl
            startGameBeginBrawl
        when 'End Game' # if they want to end the game
            endGame
        end
    end

    # this method allows the user to change the difficulty of the game
    def startGameChangeDifficulty
        system("clear") # clear console and output information about setting difficulty
        puts ColorizedString.new("Change Game Difficulty").blue
        puts "---------------------------------------------------------"
        puts "#{ColorizedString.new("NOTE: This will reset all your other changes!").light_blue}\n\n"

        # get user input
        menuSelection = $prompt.select(ColorizedString.new("Set Difficulty").red, ['Go Back', 'Civil', 
                                                                                   'Tense', 'Uncomfortable', 'Hostile', 'Badarse'])

        case menuSelection # handle user response
        when 'Civil' # easiest difficulty selection
            @difficulty = 1 # set difficulty
            populateTownHall(10) # populate the Town Hall with 10 citizens
            $max_tokens = 4 # set the max tokens
            self.tokens = $max_tokens # reset the current tokens to max tokens
            startGameMenu # go back to the current round menu
        when 'Tense' # similar to 'Civil' branch, but harder
            @difficulty = 2
            populateTownHall(13)
            $max_tokens = 6 
            self.tokens = $max_tokens
            startGameMenu
        when 'Uncomfortable' # similar to 'Tense' branch, but harder
            @difficulty = 3
            populateTownHall(20)
            $max_tokens = 8
            self.tokens = $max_tokens
            startGameMenu
        when 'Hostile' # similar to 'Uncomfortable' branch, but harder
            @difficulty = 4
            populateTownHall(30)
            $max_tokens = 10
            self.tokens = $max_tokens
            startGameMenu
        when 'Badarse' # similar to 'Badarse' branch, but harder
            @difficulty = 5
            populateTownHall(45)
            $max_tokens = 12
            self.tokens = $max_tokens
            startGameMenu
        when 'Go Back' # this option allows the user to go back to the round menu without making changes
            startGameMenu
        end
    end

    # this method prints out an overview of the game
    def startGameReadOverview
        system("clear") # clear the console

        #print the information
        puts ColorizedString.new("How Town Hall Brawl Works").blue
        puts "---------------------------------------------------------\n\n"
        puts "#{ColorizedString.new("Town Hall Brawl")} is a probability game where you must guess which initiative will be the last one left after all the citizens brawl it out!\n\n"

        puts "#{ColorizedString.new("Change Cifficulty").light_blue}: How many citizens will be fighting for their initiative - Harder = More Points For That Round"
        puts "#{ColorizedString.new("View Citizens").light_blue}: See all the citizens, how strong they are, and what they support"
        puts "      - This will help you make a decision on what initiative might win out"
        puts "#{ColorizedString.new("Edit Room").light_blue}: Use your tokens to slightly tip the odds in your favor by"
        puts "      - Arrest (delete) a citizen to reduce the strength of a specific initative"
        puts "      - Confuse (update) all the citizens' initiatives to re-roll if the initative distribution is too even"
        puts "      - Include (add) a citizen (higher chance of better stats) to make the distribution more skewed"
        puts "      - The less tokens you have, the smaller your point modifier will be, use them wisely!"
        puts "#{ColorizedString.new("Start Brawl").light_blue}: When you feel confident to make a guess, start the brawl, make a guess, and score points (if correct)"
        puts ""
        puts ColorizedString.new("Point System").blue
        puts "-----------------------------------"
        puts "#{ColorizedString.new("If Correct").light_blue}: (tokens + difficulty**2)**2"
        puts "#{ColorizedString.new("If Incorrect").light_blue}: 0\n\n"
        
        # provide a single option prompt to allow the user to go back to the current round menu
        if userSingleOption(ColorizedString.new("Back To Game Menu?").red, ['Fine, but ONLY because I WANT TO.'])
            startGameMenu
        end
  
    end

    # this method allows a user to view the game participants
    def startGameViewParticipants
        system("clear") # clear console & display header information

        puts ColorizedString.new("Current Citizens In The Room").blue
        puts "---------------------------------------------------------\n\n"
        
        Citizen.displayCitizenBeliefs # display the citizen information with their beliefs
        puts "\n\n"

        # single user prompt to go back to the current round menu
        if userSingleOption(ColorizedString.new("Back To Game Menu?").red, ['TAKE ME TO YOUR MASTE- I MEAN MENU!'])
            startGameMenu
        end
    end

    # this method provides the options to edit the room
    def startGameHedgeBetsMenu
        system("clear") # clear console and provide header information
        puts ColorizedString.new("Edit Town Hall Menu").blue
        puts "---------------------------------------------------------"
        puts "#{ColorizedString.new("You have").light_blue} #{self.tokens} #{ColorizedString.new("left.").light_blue}\n\n"
        
        # if the user still has tokens left to spend
        if self.tokens > 0
            #prompt them with the room editting options
            menuSelection = $prompt.select(ColorizedString.new("Town Hall 'Pre-Game' Options").red, ['Arrest A Citizen', 'Confuse All Citizens',
                                                                    'Insert Angry Citizen', 'Go Back'])

            case menuSelection  # handle their input
            when 'Arrest A Citizen' # if they want to arrest a citizen (remove them from the battle)
                startGameArrestCitizen
            when 'Confuse All Citizens' # if they want to re-roll all the initiatives on all the citizens
                startGameConfuseCitizens
            when 'Insert Angry Citizen' # if they want to insert a strong citizen randomly into the room
                startGameAddAngryCitizen
            when 'Go Back' # go back to the round menu
                startGameMenu
            end

        else # else if the user is out of tokens
            #tell the user
            puts "You are out of tokens, press any key to go back to the game menu\n\n"

            # navigate them back to the current round menu
            if userSingleOption(ColorizedString.new("Back to Game Menu").red, ['Yeah, yeah WUTEVER.'])
                startGameMenu
            end
        end
    end

    # this method arrests a Citizen
    def startGameArrestCitizen
        system("clear") # clear console and provide header information
        puts ColorizedString.new("Arrest A Citizen").blue
        puts "---------------------------------------------------------"
        puts ColorizedString.new("NOTE: This will reduce your available tokens by 1\n\n").light_blue

        # prompt the user for who they want to arrest
        citizenNameRequest = $prompt.select(ColorizedString.new("Who do you want to arrest? They ALL look like scumbags...").red, 
                                                                ['Go Back'] + Citizen.returnCitizenBeliefs, 
                                                                    per_page: (['Go Back'] + Citizen.returnCitizenBeliefs).size)
        
        # handle user input
        if citizenNameRequest == 'Go Back' # if the user wants to go back to the current round menu
            startGameMenu   
        elsif Citizen.getCitizenNames.include?(citizenNameRequest[0..citizenNameRequest.index('(')-2]) # or if the user selects one of the citizens
            citizenName = citizenNameRequest[0..citizenNameRequest.index('(')-2] # get the citizen's name from their 'description'
            system("clear") # clear the console
            puts "#{citizenName} was dragged out of town hall by the police! Awkward... \n" # print a heartwarming message for feedback
            
            Citizen.find_by(name: citizenName).advocacies[0].destroy # destroy the arrested citizen's advocacies
            Citizen.find_by(name: citizenName).destroy # destroy the arrested citizen
            self.tokens -= 1 # reduce the available tokens by one
            
            # navigate the user back to the current round menu
            if userSingleOption(ColorizedString.new("\n\nBack To Game Menu?").red, ["LOL, sucks to be #{citizenName}, Let's boogie!"])
                startGameMenu
            end
        end
    end

    # this method prompts the user to see if they want to confuse all the citizens
    def startGameConfuseCitizens
        system("clear") # clear console and print header information
        puts ColorizedString.new("Confuse All Citizens").blue
        puts "--------------------------------------------------------"
        puts ColorizedString.new("NOTE: This will reduce your available tokens by 1\n\n").light_blue

        # prompt the user for if they want to confuse all the citizens
        confuseCitizens = $prompt.select(ColorizedString.new("Confuse All The Citizens (Re-roll Initiatives)").red, ['Yes, blow their minds!', 'Nope JK.'])

        case confuseCitizens # handle the inputs
        when 'Yes, blow their minds!'
            confuseAllCitizens
        when 'Nope JK.'
            startGameMenu
        end   
    end

    # this method re-rolls all citizens initiatives
    def confuseAllCitizens
        puts "All the citizens in town hall came in with these beliefs\n\n" # print message
        sleep(1)
        Citizen.displayCitizenBeliefs # display the current Citizen Beliefs
        Citizen.randomizeInitiatives # randomize all citizen initiatives

        # print a funny message 
        puts ColorizedString.new("\n\nYou confuse them with poltical jargon like:").light_blue 
        4.times do 
            puts ColorizedString.new("#{Faker::Marketing.buzzwords}").light_green
            sleep(1)
        end

        # print another message for current beliefs header
        puts "\n\n"
        puts ColorizedString.new("Now their beliefs are:").light_blue
        puts "\n\n"
        sleep(1)

        Citizen.displayCitizenBeliefs # display the current citizen beliefs, that are now randomized
        
        self.tokens -= 1 # reduce the current game's tokens

        # navigate the user to the current round menu
        if userSingleOption(ColorizedString.new("\n\nBack To Game Menu?").red, ["Uh, yeah! Where else will I go? #{Faker::WorldCup.team}?"])
            startGameMenu
        end
    end

    # this method adds a stronger citizen
    def startGameAddAngryCitizen
        system("clear") # clear terminal and print header
        puts ColorizedString.new("Add An Angry Citizen").blue
        puts "--------------------------------------------------------"
        puts ColorizedString.new("NOTE: This will reduce your available tokens by 1\n\n").light_blue

        # prompt user to enter a Citizen name
        print ColorizedString.new("Type a new name for your citizen: ").light_blue
        puts "\n"

        # prompt the user for the input
        newCitizenName = getUserInput

        # create a new citizen through an association
        newAdvocacy = Advocacy.create(citizen: Citizen.create(name: newCitizenName, strength: rand(35..120), health: rand(50..120)), 
                        initiative: Initiative.all.sample)

        # provide a feedback message
        puts "\n#{newAdvocacy.citizen.name} comes strutting into town hall and announces 'I believe in #{newAdvocacy.initiative.name_and_description}'\n\n"

        self.tokens -= 1 # reduce the number of tokens on the current game

        # navigate the user back to the current round menu
        if userSingleOption(ColorizedString.new("Back To Game Menu?").red, ["Oooh, there's gonne be DRAMA today. Back to the menu!"])
            startGameMenu
        end 
    end

    # this method begins the brawl process (where all citizens with different initiatives try to eliminate each other)
    def startGameBeginBrawl
        brawlIntro # brawl intro scene (just for laughs)
        input = brawlChooseInitiative # user vote for initiative
        pointsScoredThisRound = beginBrawl(input) # brawl begins and returns the points scored

        self.score += pointsScoredThisRound # update the match score based on the points scored

        puts "Your score after the town hall brawl is #{score}." # print a score message
        self.gamesLeftToPlay -= 1 # decrement the number of games left to play for the match

        setupForNewGame # setup a new round
    end

    # this method prints the intro to a town hall brawl (fun messages)
    def brawlIntro
        system("clear")
        puts ""
        puts "Everybody please take your seats! Deliberations are about to begin"
        puts ""
    end

    # this method lets a user choose an initiative to vote for
    def brawlChooseInitiative
        system("clear") # clear console

        # get a list of unique initiatives
        uniqueInitiatives = Advocacy.all.map {|advocacy| "#{advocacy.initiative.name}: #{advocacy.initiative.description}"}.uniq

        # prompt the user with a list of initiatives to vote for
        initiativeNumber = $prompt.select("Vote for an initiative", ['Go Back'] + uniqueInitiatives, per_page: uniqueInitiatives.size + 1)

        if initiativeNumber == 'Go Back'
            startGameMenu
        end

        initiativeNumber[0...initiativeNumber.index(':')].split[1] # returns the user's choice and grab only the "Initiatve XXXX" portion of it
    end

    # this method begins a brawl given a vote
    def beginBrawl(initiative_vote)
        system("clear") # clear console
        puts "Town hall starting line up: \n\n"
        Citizen.displayCitizenBeliefs

        puts "\n\n"

        winningInitiative = Citizen.brawl # run brawl and store the winning initiative

        puts "\nYou voted for Initiative #{initiative_vote}."
        if (winningInitiative == initiative_vote) # if the winning initiatve matches the initiative that user voted for
            # congratulate the winning initiative
            puts "\nCongratulations! You picked the winning Initiative" 
            puts "Tokens left: #{self.tokens}, Difficulty level: #{self.difficulty} "
            puts "Points This Round: #{(self.tokens + self.difficulty**2)**2}\n"
            (self.tokens + self.difficulty**2)**2 # return the points they scored modified by the modifier
        else # if the user did not vote for the right initiative
            puts ColorizedString.new("\nYou lost!").red
            puts "Points This Round: 0"
            0 # return 0 points
        end
end

    # this sets up a new game
    def setupForNewGame
        self.tokens = $max_tokens # reset the tokens 
        self.difficulty = 1 # reset the difficulty
        populateTownHall(10) # re-populate the town hall with the easy difficulty
        
        if (gamesLeftToPlay < 0) # if there are no more games to play (match is over)
            puts "You reached the end of the match, you are a champion of democracy!\n\n" # print a 'match end' message
            
            self.score = 0 # reset the score
            self.gamesLeftToPlay = MAX_ROUNDS

            if userSingleOption("Start New Match?", ["Consider me addicted!"]) # navigate the user to the start menu
                startGameMenu
            end

        else # else if there are still games left to play (match continues)

            puts "You have #{self.gamesLeftToPlay} rounds left!\n\n" # tell the user how many matches they have left to play
            
            # navigate them to the current round menu
            if userSingleOption("Play Next Game?", ["Heck Yeah!"])
                startGameMenu
            end
        end

    end

    # this method ends the game
    def endGame
        puts "\nThanks for playing, hope to see you again at our next town hall meeting!" # prints end message
        exit
    end

    #---------------------------------------------------------------------------------------------------------------------------#
    #-----------------------------------------------------HELPER METHODS--------------------------------------------------------#
    #---------------------------------------------------------------------------------------------------------------------------#

    # creates a specific number of initiative variations (as arrays, not initiative objects) and pushes them into the final array
    def createInitiativeVariations(numberOf)
        numberOf.times do
            $final_array << ["#{assignRandomInitiativeNumber}", "Make #{Faker::Name.first_name} the #{Faker::Creature::Animal.name} turn the music down!"]
            $final_array << ["#{assignRandomInitiativeNumber}", "Make #{Faker::Verb.ing_form} illegal!"]
            $final_array << ["#{assignRandomInitiativeNumber}", "Subsidize #{Faker::Food.dish} stands to attract more #{Faker::Company.profession}s to our town!"]
            $final_array << ["#{assignRandomInitiativeNumber}", "Increase surveillance on the #{Faker::Dessert.variety} cult!"]
            $final_array << ["#{assignRandomInitiativeNumber}", "Update the swimming pool's safety board language to #{Faker::Nation.language}!"]
            $final_array << ["#{assignRandomInitiativeNumber}", "Prevent the #{Faker::Space.agency} from parking their #{Faker::Space.launch_vehicle} in my yard!"]
            $final_array << ["#{assignRandomInitiativeNumber}", "Make it legal for me to drive my #{Faker::Construction.heavy_equipment} across the baseball field!"]
            $final_array << ["#{assignRandomInitiativeNumber}", "#{Faker::ElectricalComponents.electromechanical}s aren't real. Erase them from the dictionary!"]
            $final_array << ["#{assignRandomInitiativeNumber}", "Genetically clone #{Faker::Science.scientist} and send them to #{Faker::Space.planet}!"]
            $final_array << ["#{assignRandomInitiativeNumber}", "Promote Salty Joe to #{Faker::Military.air_force_rank} and send him out to #{Faker::Space.star}!"]
            $final_array << ["#{assignRandomInitiativeNumber}", "Reclaim the #{Faker::Games::Zelda.item} from those pesky #{Faker::Company.profession}s in #{Faker::Games::Zelda.location}!"]
            $final_array << ["#{assignRandomInitiativeNumber}", "Award #{rand(1..400000)} points to #{Faker::Movies::HarryPotter.house}!"]
            $final_array << ["#{assignRandomInitiativeNumber}", "All #{Faker::Creature::Animal.name}s should be knighted!"]
        end
    end

    # create initiatives randomly from the initiatives in final_array
    def createInitiativesFromVariations(numberOf)
        numberOf.times do
            selected_pair = $final_array.sample
            Initiative.create(name: selected_pair[0], description: selected_pair[1])
        end
    end

    # creates a specific number of citizens with random health and strength
    def createCitizens(numberOf)
        # create citizens
        numberOf.times do
            Citizen.create(name: Faker::FunnyName.name, strength: rand(10..35), health: rand(30..100))
        end

        # associate citizens with random initiatives
        Citizen.all.each do |citizen|
            Advocacy.create(citizen: citizen, initiative: Initiative.all.sample)
        end
    end

    # populates a town hall with a specific number of citizens who support random initiatives
    def populateTownHall(number_of_citizens)
        clearTownHall
        createInitiativeVariations(4)
        createInitiativesFromVariations(10)
        createCitizens(number_of_citizens)
    end

    # clears town hall of all objects for a new match
    def clearTownHall()
        Advocacy.destroy_all
        Citizen.destroy_all
        Initiative.destroy_all
    end

    # generates a random initiative number and returns it if the initiative doesn't already exist in the initiatives array
    def assignRandomInitiativeNumber
        initiativeString = "Initiative #{rand(1..2000)}"

        until !$final_array.flatten.include?(initiativeString) do
            initiativeString = "Initiative #{rand(1..2000)}"    
        end

        initiativeString
    end

    #outputs with a sleep duration at the end
    def puts_sleep(message, duration)
        puts message
        sleep(duration)
    end
    
    #prints with a sleep duration at the end
    def print_sleep(message, duration)
        print message
        sleep(duration)
    end

end