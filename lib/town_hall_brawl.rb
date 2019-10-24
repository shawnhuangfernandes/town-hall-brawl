require 'tty-prompt'

class TownHallBrawl
    $prompt = TTY::Prompt.new

    attr_accessor :difficulty, :tokens, :score, :gamesLeftToPlay, :points

    def initialize(tokens = 3, points = 0, difficulty = 1, gamesLeftToPlay = 5, score = 0)
        @tokens = tokens
        @points = points
        @score = score
        @difficulty = difficulty
        @gamesLeftToPlay = gamesLeftToPlay

        populateTownHall(10)
    end
    
    $final_array = []
    $difficulty_level = ["Civil", "Tense", "Uncomfortable", "Hostile", "Bad@ss"]
    $max_tokens = 4
    MAX_ROUNDS = 5

    def userSingleOption(question, option)
        $prompt.select(question, [option])
    end

    def getUserInput
        print "Enter your input: "
        gets.chomp
    end

    def gameStartup
        system("clear")
        sleep(3)
        puts "Town Hall Meetings are the pinnacle of human evolution"
        sleep(2)
        print "Individuals come together"
        sleep (2)
        print " from all walks of life"
        sleep (2)
        puts " to do what humans do best:"
        sleep(2)
        puts "\nCOMPLAIN"
        sleep (2)
        puts "\nBut what if we had a different kind of town hall meeting"
        sleep (3)
        print "Where things got done, "
        sleep(2)
        print "decisions were made"
        sleep(2)
        print " and only"
        sleep(2)
        print " the greatest,"
        sleep(2)
        print " most delicious,"
        sleep(2.5)
        print " most disgustingly amazing,"
        sleep(2)
        puts " ideas became reality."
        sleep(2)
        puts "\nThis isn't just ANY town hall meeting"
        sleep(2)
        print "\nTHIS"
        sleep(2)
        puts " IS\n\n"
        sleep(2)
        puts "TOWN HALL BRAWL!"
        sleep(2)
        puts "\nMade by Shawn Huang Fernandes\n"

        sleep(4)
        gameMenuSelection
        
    end

    def gameMenuSelection
        system("clear")

        menuSelection = $prompt.select("Would you like to Play Town Hall Brawl?", ['Yes, I would!', 'NO! Be gone you fiend!'])

        case menuSelection
        when 'Yes, I would!'
            startGameMenu
            clearGameStats
        when 'NO! Be gone you fiend!'
            endGame
        end
    end

    def startGameMenu
        system("clear")
        
        puts "Current Game\n#{gamesLeftToPlay} games left until end of match\n"

        menuSelection = menuSelection = $prompt.select("What would you like to do?", ['Game Overview', 'Change Difficulty',
                                                                                'View Citizens', 'Edit Room', "Start Brawl", 'End Game'])

        case menuSelection
        when 'Game Overview'
            startGameReadOverview
        when 'Change Difficulty'
            startGameChangeDifficulty
        when 'View Citizens'
            startGameViewParticipants
        when 'Edit Room'
            startGameHedgeBetsMenu
        when 'Start Brawl'
            startGameBeginBrawl
        when 'End Game'
            endGame
        end
    end

    def startGameChangeDifficulty
        system("clear")

        menuSelection = $prompt.select("Set Difficulty", ['Civil', 'Tense', 'Uncomfortable', 'Hostile', 'Bad@ass', 'Go Back'])

        case menuSelection
        when 'Civil'
            @difficulty = 1
            populateTownHall(10)
            $max_tokens = 4
            startGameMenu
        when 'Tense'
            @difficulty = 2
            populateTownHall(13)
            $max_tokens = 6
            startGameMenu
        when 'Uncomfortable'
            @difficulty = 3
            populateTownHall(20)
            $max_tokens = 8
            startGameMenu
        when 'Hostile'
            @difficulty = 4
            populateTownHall(30)
            $max_tokens = 10
            startGameMenu
        when 'Bad@ss'
            @difficulty = 5
            populateTownHall(45)
            $max_tokens = 12
            startGameMenu
        when 'Go Back'
            startGameMenu
        end
    end

    def startGameReadOverview
        system("clear")
        puts ""
        puts "How Town Hall Brawl Works"
        puts "-----------------------------------"
        puts "Choose A Difficulty: How many citizens will be fighting for their initiative - Harder = More Points"
        puts "View The Room: See all the citizens, how strong they are, and what they support"
        puts "      - This will help you make a decision on what initiative might win out"
        puts "Hedge Your Bets: Use your tokens to slightly tip the odds in your favor by"
        puts "      - Arrest (delete) a citizen to reduce the strength of a specific initative"
        puts "      - Confuse (update) all the citizens' initiatives to re-roll if the initative distribution is too even"
        puts "      - Include (add) a citizen (higher chance of better stats) to make the distribution more skewed"
        puts "Brawl it OUT: When you feel confident to make a guess, start the brawl, make a guess, and score points (if correct)"
        puts ""
        puts "Point System"
        puts "-----------------------------------"
        puts "If Correct: (number_of_tokens_leftover) * (total_citizens_in_room)"
        puts "If Not Correct: 0"
        puts ""
        puts "Press any key to go back to the game menu"
        puts ""


        if getUserInput
            startGameMenu
        end
  
    end

    def startGameViewParticipants
        system("clear")
        puts ""
        puts "Current Citizens In The Room"
        puts "-----------------------------------------"
        
        Citizen.displayCitizenBeliefs

        puts ""
        puts "Press any key to go back to the game menu"
        puts ""


        if getUserInput
            startGameMenu
        end
    end

    def startGameHedgeBetsMenu
        system("clear")
        puts ""
        
        if self.tokens > 0
            menuSelection = $prompt.select("Town Hall 'Pre-Game' Options", ['Arrest A Citizen', 'Confuse All Citizens',
                                                                    'Insert Angry Citizen', 'Go Back'])

            case menuSelection
            when 'Arrest A Citizen'
                startGameArrestCitizen
            when 'Confuse All Citizens'
                startGameConfuseCitizens
            when 'Insert Angry Citizen'
                startGameAddAngryCitizen
            when 'Go Back'
                startGameMenu
            end
        else
            puts "You are out of tokens, press any key to go back to the game menu"
            if getUserInput
                startGameMenu
            end
        end
    end

    def startGameArrestCitizen
        system("clear")
        puts "NOTE: This will reduce your available tokens by 1"
        puts "--------------------------------------------------------"

        puts ""

        citizenNameRequest = $prompt.select("Who do you want to arrest? They ALL look like scumbags...", ['Go Back'] + Citizen.returnCitizenBeliefs, per_page: (['Go Back'] + Citizen.returnCitizenBeliefs).size)
        citizenName = citizenNameRequest[0..citizenNameRequest.index('(')-2]
        if citizenNameRequest == 'Go Back'
            puts ""
            startGameMenu
            binding.pry
        elsif Citizen.getCitizenNames.include?(citizenName)
            system("clear")
            puts "#{citizenName} was dragged out of town hall by the police! Awkward... \n"
            
            Citizen.find_by(name: citizenName).advocacies[0].destroy
            Citizen.find_by(name: citizenName).destroy
            self.tokens -= 1
            
            if getUserInput
                startGameMenu
            end
        end
    end

    def startGameConfuseCitizens
        system("clear")
        puts "NOTE: This will reduce your available tokens by 1"
        puts "--------------------------------------------------------"
        puts ""

        confuseCitizens = $prompt.select("Confuse All The Citizens (Re-roll Initiatives)", ['Yes', 'No'])

        case confuseCitizens
        when 'Yes'
            confuseAllCitizens
        when 'No'
            startGameMenu
        end   
    end

    def confuseAllCitizens
        puts "All the citizens in town hall came in with these beliefs"
        puts ""
        sleep(1)
        Citizen.displayCitizenBeliefs
        puts ""
        Citizen.randomizeInitiatives
        puts "You confuse them with poltical jargon like:"
        puts "#{Faker::Marketing.buzzwords}"
        sleep(1)
        puts "#{Faker::Marketing.buzzwords}"
        sleep(1)
        puts "#{Faker::Marketing.buzzwords}"
        sleep(1)
        puts "#{Faker::Marketing.buzzwords}" 
        sleep(1)
        puts ""
        puts "Now their beliefs are:"
        puts ""
        sleep(1)

        Citizen.displayCitizenBeliefs
        
        self.tokens -= 1

        puts "Press any key to go back to the game menu"
        puts ""

        if getUserInput
            startGameMenu
        end
    end

    def startGameAddAngryCitizen
        system("clear")
        puts "NOTE: This will reduce your available tokens by 1"
        puts "-----------------------------------------------"
        puts ""

        puts "Add a citizen to the 'meeting'"
        puts "Type a new name for your citizen"
        puts ""

        newCitizenName = getUserInput

        newAdvocacy = Advocacy.create(citizen: Citizen.create(name: newCitizenName, strength: rand(35..75), health: rand(50..150)), 
                        initiative: Initiative.all.sample)
        puts "#{newAdvocacy.citizen.name} comes strutting into town hall and announces 'I believe in #{newAdvocacy.initiative.name}': #{newAdvocacy.initiative.description}"
        puts ""

        self.tokens -= 1

        puts "Press any key to go back to the game menu"
        puts ""

        if getUserInput
            startGameMenu
        end
        
    end

    def startGameBeginBrawl
        brawlIntro
        input = brawlChooseInitiative
        pointsScoredThisRound = beginBrawl(input)

        self.score += pointsScoredThisRound

        puts "Your score after the town hall brawl is #{score}."
        self.gamesLeftToPlay -= 1

        if(self.gamesLeftToPlay < 0)
            setupForNewGame
            self.score = 0
            self.difficulty = 1
        else
            setupForNewGame
        end

        if getUserInput
            startGameMenu
        end  
    end

    def setupForNewGame
        if (gamesLeftToPlay < 0)
            puts "You reached the end of the match, you are a champion of democracy!"
            puts "Press any key to start a new match!"
        else
            puts "You have #{self.gamesLeftToPlay} rounds left!"
            puts "Press any key to go back to play the next round"
        end
        self.tokens = $max_tokens
        populateTownHall(6)
        puts ""
    end

    def brawlIntro
        system("clear")
        puts ""
        puts "Everybody please take your seats! Deliberations are about to begin"
        puts ""

        townHallRandomEvents
    end

    def townHallRandomEvents
        # end with a clear
    end

    def brawlChooseInitiative
        system("clear")

        uniqueInitiatives = Advocacy.all.map {|advocacy| "#{advocacy.initiative.name}: #{advocacy.initiative.description}"}.uniq

        initiativeNumber = $prompt.select("Vote for an initiative", uniqueInitiatives, per_page: uniqueInitiatives.size)

        initiativeNumber[0...initiativeNumber.index(':')]
    end

    def beginBrawl(initiative_vote)
            system("clear")
            winningInitiative = Citizen.brawl
            if (winningInitiative == initiative_vote)
                puts "\nCongratulations! You picked the winning Initiative"
                puts "Tokens left: #{self.tokens}, Difficulty level: #{self.difficulty} "
                puts "Points This Round: #{(self.tokens + self.difficulty**2)**2}\n"
                (self.tokens + self.difficulty)**2
            else
                puts "You lost!"
                puts "Points This Round: 0"
                0
            end
    end

    def endGame
        puts "\nThanks for playing, hope to see you again at our next town hall meeting!"
        exit
    end

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

    def createCitizens(numberOf)
        numberOf.times do
            Citizen.create(name: Faker::FunnyName.name, strength: rand(10..35), health: rand(30..100))
        end

        Citizen.all.each do |citizen|
            Advocacy.create(citizen: citizen, initiative: Initiative.all.sample)
        end
    end

    def createInitiativesFromVariations(numberOf)
        numberOf.times do
            selected_pair = $final_array.sample
            Initiative.create(name: selected_pair[0], description: selected_pair[1])
        end
    end

    def clearTownHall()
        Advocacy.destroy_all
        Citizen.destroy_all
        Initiative.destroy_all
    end

    def clearGameStats
        self.tokens = $max_tokens
    end

    def clearMatchStats
        self.score = 0
        self.gamesLeftToPlay = 5
    end

    def populateTownHall(number_of_citizens)
        clearTownHall
        createInitiativeVariations(4)
        createInitiativesFromVariations(10)
        createCitizens(number_of_citizens)
    end

    def assignRandomInitiativeNumber
        initiativeString = "Initiative #{rand(1..2000)}"

        until !$final_array.flatten.include?(initiativeString) do
            initiativeString = "Initiative #{rand(1..2000)}"    
        end

        initiativeString
    end
end