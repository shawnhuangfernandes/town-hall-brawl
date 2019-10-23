class TownHallBrawl

    $final_array = []

    def getUserInput
        gets.chomp
    end

    def gameStartup
        puts "Welcome to Town Hall Brawl, a game about..."
        puts "friendship"
        puts "spaceships"
        puts "occasionally... Salty Joe"
        puts "cults centered around food"
        puts "really adorable violence"
        puts "and... democracy!"
        puts "Made by Shawn Huang Fernandes"
    end

    def gameMenuSelection
        puts "Game Options (options are the numbers)"
        puts "-----------------------------------"
        puts ""
        puts "1. Start Game"
        puts "2. Stop Playing"  
    end

    def startGameMenu
        # this prints the options when you start a game
        
        # 1. Read Overview
        # 2. Change Difficulty (Current Difficulty Level)
        # 3. View Participants
        # 4. Hedge Your Bet (Number of tokens left)
        # 5. BEGIN TOWN HALL BRAWL!

        # Prompt for value
        # Run Switch/Case
    end

    def startGameChangeDifficulty
        # print Out Difficulties
        
        # 1. Civil (6 people - 6 * token modifier)
        # 2. Tense (10 people - 10 * token modifier)
        # 3. Uncomfortable (15 people - 15 * token modifier)
        # 4. Hostile (20 people - 20 * token modifier)
        # 5. Bad@ss (30 people - 30 * token modifier)
        # 6. Back to menu
        
        # Prompt for value
        # Run Switch/Case
    end

    def startGameReadOverview
        # print the overview
        
        # Loop back to startGameMenu
    end

    def startGameViewParticipants
        # print out a list of participants and their initiatives
        
        # Loop back to the startGameMenu
    end

    def startGameHedgeBetsMenu
        # list out the number of tokens a user has left
        # provide a list of options
        
        # 1. Arrest Citizen (remove citizen)
        # 2. Confuse Citizen (change citizen's initiative)
        # 3. Supercharge Citizen (Increase citizen's health and strength)
        # 4. Go back to start game menu

        # switch/case
    end

    def startGameArrestCitizen
        # provide a list of citizens
        # prompt user for a citizen name whom they want to arrest

        # if the name is valid
        # remove that citizen from the database
        # else
        # startGameArrestCitizen
    end

    def startGameConfuseCitizens
        # Ask if they want to confuse all the citizens

        # if yes
        # reroll everyone's initiatives
        # if no
        # go back to startGameMenu
        # else
        # re do confuse citizens
    end

    def startGameSuperchargeCitizen
        # provide a list of citizens
        # prompt user for a citizen name whom they want to supercharge

        # if the name is valid
        # supercharge that citizen
        # elsif wants to exit
        # back to startGameMenu
        # else
        # not valid input re do supercharge
    end

    def startGameBeginBrawl
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

    def createInitiativeVariations(numberOf)
        numberOf.times do
            $final_array << ["Initiative #{rand(1..2000)}", "Make #{Faker::Name.first_name} the #{Faker::Creature::Animal.name} turn the music down!"]
            $final_array << ["Initiative #{rand(1..2000)}", "Make #{Faker::Verb.ing_form} illegal!"]
            $final_array << ["Initiative #{rand(1..2000)}", "Subsidize #{Faker::Food.dish} stands to attract more #{Faker::Company.profession}s to our town!"]
            $final_array << ["Initiative #{rand(1..2000)}", "Increase surveillance on the #{Faker::Dessert.variety} cult!"]
            $final_array << ["Initiative #{rand(1..2000)}", "Update the swimming pool's safety board language to #{Faker::Nation.language}!"]
            $final_array << ["Initiative #{rand(1..2000)}", "Prevent the #{Faker::Space.agency} from parking their #{Faker::Space.launch_vehicle} in my yard!"]
            $final_array << ["Initiative #{rand(1..2000)}", "Make it legal for me to drive my #{Faker::Construction.heavy_equipment} across the baseball field!"]
            $final_array << ["Initiative #{rand(1..2000)}", "#{Faker::ElectricalComponents.electromechanical}s aren't real. Erase them from the dictionary!"]
            $final_array << ["Initiative #{rand(1..2000)}", "Genetically clone #{Faker::Science.scientist} and send them to #{Faker::Space.planet}!"]
            $final_array << ["Initiative #{rand(1..2000)}", "Promote Salty Joe to #{Faker::Military.air_force_rank} and send him out to #{Faker::Space.star}!"]
            $final_array << ["Initiative #{rand(1..2000)}", "#{Faker::Books::Lovecraft.fhtagn}!"]
            $final_array << ["Initiative #{rand(1..2000)}", "Reclaim the #{Faker::Games::Zelda.item} from those pesky #{Faker::Company.profession}s in #{Faker::Games::Zelda.location}!"]
            $final_array << ["Initiative #{rand(1..2000)}", "Award #{1..400000} points to #{Faker::Movies::HarryPotter.house}!"]

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

    def createInitiativesFromTypes(numberOf)
        numberOf.times do
            selected_pair = $final_array.sample
            Initiative.create(name: selected_pair[0], description: selected_pair[1])
        end
    end
end