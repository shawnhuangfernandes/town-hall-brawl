class TownHallBrawl
    attr_accessor :difficulty, :tokens

    def initialize(tokens = 3, points = 0, difficulty = 1)
        @tokens = tokens
        @points = points
        @difficulty = difficulty

        populateTownHall(6)
    end
    
    $final_array = []
    $difficulty_level = ["Civil", "Tense", "Uncomfortable", "Hostile", "Bad@ss"]

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
        
        
        gameMenuSelection
    end

    def gameMenuSelection
        system("clear")
        puts ""
        puts "Game Options (options are the numbers)"
        puts "-----------------------------------"
        puts ""
        puts "1. Start Game"
        puts "2. Stop Playing"
        puts ""
        
        menuSelection = getUserInput

        case menuSelection
        when '1'
            startGameMenu
        when '2'
            endGame
        else
            puts "Errrr... You typed #{menuSelection}, try again!"
            gameMenuSelection
        end
    end

    def startGameMenu
        system("clear")
        puts ""
        puts "Current Brawl Options (options are the numbers)"
        puts "-----------------------------------"
        puts ""
        puts "1. Read Overview"
        puts "2. Change Difficulty (Currently: #{$difficulty_level[self.difficulty - 1]})"
        puts "3. View Participants"
        puts "4. Hedge Your Bet (Tokens left: #{self.tokens} Tokens)"
        puts "5. BEGIN TOWN HALL BRAWL!"
        puts "6. End Game"
        puts ""

        menuSelection = getUserInput

        case menuSelection
        when '1'
            startGameReadOverview
        when '2'
            startGameChangeDifficulty
        when '3'
            startGameViewParticipants
        when '4'
            startGameHedgeBetsMenu
        when '5'
            startGameBeginBrawl
        when '6'
            endGame
        else
            puts "Errrr... You typed #{menuSelection}, try again!"
            startGameMenu
        end
    end

    def startGameChangeDifficulty
        system("clear")
        puts ""
        puts "Game Difficulty Options (options are the numbers)"
        puts "NOTE: This resets the entire brawl (including tokens)"
        puts "-----------------------------------"
        puts ""
        puts "1. Civil (6 people: Score = 6 * token modifier)"
        puts "2. Tense (10 people: Score = 10 * token modifier)"
        puts "3. Uncomfortable (15 people: Score = 15 * token modifier)"
        puts "4. Hostile (20 people: Score = 20 * token modifier)"
        puts "5. Bad@ss (30 people: Score = 30 * token modifier)"
        puts "6. Back To Menu (Make No Changes)"
        puts ""

        menuSelection = getUserInput

        case menuSelection
        when '1'
            @difficulty = 1
            populateTownHall(6)
        when '2'
            @difficulty = 2
            populateTownHall(10)
        when '3'
            @difficulty = 3
            populateTownHall(15)
        when '4'
            @difficulty = 4
            populateTownHall(20)
        when '5'
            @difficulty = 5
            populateTownHall(30)
        when '6'
            startGameMenu
        else
            puts "Errrr... You typed #{menuSelection}, try again!"
            startGameChangeDifficulty
        end

        startGameMenu
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
        puts "Bet Hedging Menu - #{self.tokens} left"
        puts "-----------------------------------"
        puts ""
        puts "1. Arrest Citizen (remove citizen)"
        puts "2. Confuse Citizens (randomize all citizens' initiatives)"
        puts "3. Insert Angry Citizen (create a new strong citizen - random initiative)"
        puts "4. Back To Game Menu"
        puts ""
        
        if self.tokens > 0
            menuSelection = getUserInput

            case menuSelection
            when '1'
                startGameArrestCitizen
            when '2'
                startGameConfuseCitizens
            when '3'
                startGameAddAngryCitizen
            when '4'
                startGameMenu
            else
                puts "Errrr... You typed #{menuSelection}, try again!"
                startGameHedgeBetsMenu
            end
        else
            puts "You are out of tokens, press any key to go back to the game menu"
            if getUserInput
                startGameMenu
            end
        end
        startGameMenu
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
            Citizen.find_by(name: citizenNameRequest).destroy
            self.tokens -= 1
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

        puts "If you'd like to add a custom citizen to the figh- I mean town hall meeting"
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
            
            self.tokens -= 1
        end
    end

    def startGameBeginBrawl
        system("clear")
        puts ""
        puts "Everybody please take your seats! Deliberations are about to begin"
        puts ""

        townHallRandomEvents

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

        if uniqueInitiativeNames.map {|initiative_string| initiative_string.split[1]}.include?(initiativeNumber)
            Citizen.brawl
        else
            puts "You entered #{initiativeNumber}, which is invalid, try again!"

        end
        # have the user select an initiative by number - the one they think will be the last one
        # run Brawl
        # check to see if they are right

        # if they are, set their points += to token * difficultyModifier

        # if not, they get 0 points

        # ask them if they want to play again? (y/n)

        # y - start again and reset tokens and points and database
        # n - exit message and end program
        # else "I don't understand what you mean, so you must want to keep playing" - start again anyway
    end

    def townHallRandomEvents

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
            Citizen.create(name: Faker::FunnyName.name, strength: rand(1..25), health: rand(15..100))
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