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

        populateTownHall(6)
    end
    
    $final_array = []
    $difficulty_level = ["Civil", "Tense", "Uncomfortable", "Hostile", "Bad@ss"]
    MAX_TOKENS = 3
    MAX_ROUNDS = 5

    def getUserInput
        print "Enter your input: "
        gets.chomp
    end

    def gameStartup
        system("clear")
        puts ""
        puts "Welcome to Town Hall Brawl, a game about..."
        puts "friendship"
        puts "spaceships"
        puts "occasionally... Salty Joe"
        puts "cults centered around food"
        puts "really adorable violence"
        puts "and... democracy!"
        puts "Made by Shawn Huang Fernandes"
        puts ""

        puts "Press any key to proceed to the game menu"
        puts ""

        if getUserInput
            gameMenuSelection
        end
        
    end

    def gameMenuSelection
        system("clear")

        menuSelection = $prompt.select("Would you like to Play?", ['Yes, I would!', 'NO! Be gone you fiend!'])

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
        puts ""

        menuSelection = menuSelection = $prompt.select("Current Town Hall Session Options", ['Game Overview', 'Change Difficulty',
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
            populateTownHall(6)
            startGameMenu
        when 'Tense'
            @difficulty = 2
            populateTownHall(10)
            startGameMenu
        when 'Uncomfortable'
            @difficulty = 3
            populateTownHall(15)
            startGameMenu
        when 'Hostile'
            @difficulty = 4
            populateTownHall(20)
            startGameMenu
        when 'Bad@ss'
            @difficulty = 5
            populateTownHall(30)
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
        puts "type 'q' to go back the the game manu"
        puts "Here's the list of citizens in town hall today:"
        puts ""

        Citizen.displayCitizenBeliefs

        puts ""
        puts "Who do you want to arrest? They all look like scumbags to me..."
        puts ""

        citizenNameRequest = getUserInput

        if citizenNameRequest == 'q'
            puts ""
            startGameMenu
        elsif Citizen.getCitizenNames.include?(citizenNameRequest)
            puts "#{citizenNameRequest} was dragged out of town hall by the police!"
            
            Citizen.find_by(name: citizenNameRequest).advocacies[0].destroy
            Citizen.find_by(name: citizenNameRequest).destroy
            self.tokens -= 1
            
            if getUserInput
                startGameMenu
            end
        else
            puts "#{citizenNameRequest} isn't in Town Hall today, lucky biscuit. Pick again!"
            startGameArrestCitizen
        end
    end

    def startGameConfuseCitizens
        system("clear")
        puts "NOTE: This will reduce your available tokens by 1"
        puts "--------------------------------------------------------"
        puts ""

        puts "Would you like to confuse all the citizens? (re-roll their initiatives)"
        puts "type 'y' for YES or 'n' for NO (go back to menu)"

        confuseCitizens = getUserInput

        case confuseCitizens
        when 'y'
            confuseAllCitizens
        when 'n'
            startGameMenu
        else
            puts "You said #{confuseCitizens}, which is invalid, try again!"
            startGameConfuseCitizens
        end
        
    end

    def confuseAllCitizens
        puts "All the citizens in town hall came in with these beliefs"
        puts ""
        Citizen.displayCitizenBeliefs
        puts ""
        Citizen.doSomePolitics
        puts "You confuse them with poltical jargon like:"
        puts "#{Faker::Marketing.buzzwords}"
        puts "#{Faker::Marketing.buzzwords}"
        puts "#{Faker::Marketing.buzzwords}"
        puts "#{Faker::Marketing.buzzwords}" 
        puts ""
        puts "Now their beliefs are:"
        puts ""
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
        puts "Or, type 'q' to go back to the menu"
        puts ""

        newCitizenName = getUserInput

        if newCitizenName == 'q'
            startGameMenu
        else
            newAdvocacy = Advocacy.create(citizen: Citizen.create(name: newCitizenName, strength: rand(35..75), health: rand(50..150)), 
                         initiative: Initiative.all.sample)
            puts "#{newAdvocacy.citizen.name} comes strutting into townhall and announces 'I believe in #{newAdvocacy.initiative.name}': #{newAdvocacy.initiative.description}"
            puts ""

            puts "Press any key to go back to the game menu"
            puts ""
    
            self.tokens -= 1

            if getUserInput
                startGameMenu
            end
            

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
        self.tokens = MAX_TOKENS
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
        puts "Here are the initiatives by name:"
        puts "----------------------------------"
        uniqueInitiativeNames = Citizen.all.map {|citizen| citizen.initiatives[0].name_and_description}.uniq
        uniqueInitiativeNames.each do |initiative_string|
            puts initiative_string
        end

        puts ""
        puts "Enter the initiative's number (e.g 1328) which you think will win"
        puts ""

        initiativeNumber = getUserInput

        if uniqueInitiativeNames.map {|initiative_string| initiative_string.split[1]}.exclude?(initiativeNumber)
            puts "invalid initiative, please try again!"
            puts ""
            brawlChooseInitiative
        else
            initiativeNumber
        end
    end

    def beginBrawl(initiative_vote)
            system("clear")
            winningInitiative = Citizen.brawl
            if (winningInitiative == initiative_vote)
                puts ""
                puts "Congratulations! You picked the winning Initiative"
                puts "Tokens left: #{self.tokens}, Difficulty level: #{self.difficulty} "
                puts "Points This Round: #{(self.tokens + self.difficulty**2)**2}"
                puts ""
                (self.tokens + self.difficulty)**2
            else
                puts "You lost!"
                puts "Points This Round: 0"
                0
            end
    end

    def finishedMatch
        
    end

    def endGame
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
            $final_array << ["#{assignRandomInitiativeNumber}", "Those citizens wearing or having worn highly reflective sunglasses after sundown in the summer while standing in or near the front row of a concert (rock or otherwise) shall be asked to reimburse the artists responsible for the concert in a monetary amount equivalent to or exceeding the correlated emotional damages incurred by the artist from being coerced into the sightline of a person of a demonstrably higher level of cool than themselves."]
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
        self.tokens = MAX_TOKENS
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