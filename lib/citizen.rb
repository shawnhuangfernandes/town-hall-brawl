class Citizen < ActiveRecord::Base
    has_many :advocacies # relationship - a citizen has many advocacies
    has_many :initiatives, through: :advocacies # relationship - a citizen has many initiatives through advocacies
    
    # list of action verbs
    ACTION_VERB = ["obliterated", "eviscerated", "eliminated", "absolutely mopped the floor with", "bamboozled",
                   "creamed", "wasted", "destroyed", "physically-vetoed", "pwned", "clobbered", "sliced n' diced",
                   "annihilated", "vaporized", "wrecked", "crushed", "slayed", "opened a can of whoop-@ss on", 
                   "thrashed", "whipped", "pulverized" , "blew up", "KABLOOIED", "KABLAMO'd", "totally just HONK HONK'd all over"]

    # this class method makes all the citizens with conflicting initiatives delete each other (fight) until only 1 initiative remains
    def self.brawl()
        until Advocacy.all.map {|advocacy| advocacy.initiative.name}.uniq.size <= 1 do # until we only have one initiative in play
            currentCitizen = Citizen.all.shuffle.first # randomize the list of citizens and grab the first in the list
            conflictingCitizen = Citizen.all.detect do |otherCitizen| # find the first citizen who has a conflicting initiative
                currentCitizen.initiatives != otherCitizen.initiatives
            end

            if conflictingCitizen # if we have found a conflicting Citizen
                brawlSession(currentCitizen, conflictingCitizen) # start a brawl session between both citizens
            end
        end

        if (Citizen.all.count == 0) # if there are no citizens left 
            puts "Well, this is awkward... looks like everyone #{ACTION_VERB.sample} each other. Nobody's left!" # print a message
        else # else if there is more than one citizen left (all with the same initiative)
            puts "#{ColorizedString.new("\n\nThe initative that's going to pass is: ").blue}\n#{Citizen.all.first.initiatives[0].name} : #{Citizen.all.first.initiatives[0].description}\n"
            Citizen.all.first.initiatives[0].name.split[1] # grab the name of the initiative that won
        end
    end

    # this method makes two citizens duke it out
    def self.brawlSession(citizen1, citizen2)
        until citizen1.health <= 0 || citizen2.health <= 0 # until either one or both citizens are DEAD
        citizen1.health -= rand(citizen2.strength/1.5..citizen2.strength) # make citizen2 hit citizen1
        citizen2.health -= rand(citizen1.strength/1.5..citizen1.strength) # make citizen1 hit citizen2
        citizen1.save # update their health
        citizen2.save # update their health
        end

        # if citizen 2 is dead and citizen 1 is alive
        if (citizen1.health > 0 && citizen2.health <= 0)
            destroyCitizen(citizen2) # destroy citizen 2
            puts "#{citizen1.name} #{ACTION_VERB.sample} #{citizen2.name}!" # display a fun 'outcome' message
        elsif (citizen1.health <= 0 && citizen2.health > 0) # if citizen 1 is dead and citizen 2 is alive
            destroyCitizen(citizen1) # destroy citizen 1
            puts "#{citizen2.name} #{ACTION_VERB.sample} #{citizen1.name}!" # display a fun 'outcome' message
        elsif (citizen1.health <= 0 && citizen2.health <= 0) # else if both citizens are dead
            destroyCitizen(citizen1) # destroy citizen 1
            destroyCitizen(citizen2) # destroy citizen 2
            puts "#{citizen1.name} and #{citizen2.name} #{ACTION_VERB.sample} each other!" # display a fun 'outcome' message
        end
        pid = fork{ exec 'afplay' ,"./sounds/death#{rand(1..14)}.mp3"}

        sleep(1.5)
    end

    # this method destroys a citizen and their advocacy
    def self.destroyCitizen(citizen)
        Advocacy.destroy(citizen.advocacies[0].id)
        destroy(citizen.id)
    end

    # this method orders all citizens and their beliefs, and color codes the display for ease of viewing
    def self.displayCitizenBeliefs   
        citizens_grouped_by_initiative = Citizen.all.sort_by {|citizen| citizen.initiatives[0].name} # order all citizens by initiative

        # display the ordered citizen info list and color code it
        citizens_grouped_by_initiative.each do |citizen|
            first_term_length = "#{citizen.name} (HLTH: #{citizen.health}/STR: #{citizen.strength}) is in favor of".length
            print "#{ColorizedString.new(citizen.name).green} (HLTH: #{ColorizedString.new(citizen.health.to_s).blue}/STR: #{ColorizedString.new(citizen.strength.to_s).red})"
            (55-first_term_length).times do
                print " "
            end

            puts "#{ColorizedString.new(citizen.initiatives[0].name).light_green} : #{citizen.initiatives[0].description}"
        end
    end

    # this method returns the citizen beliefs (for use in menus)
    def self.returnCitizenBeliefs
        citizens_grouped_by_initiative = Citizen.all.sort_by {|citizen| citizen.initiatives[0].name}
        
        citizens_grouped_by_initiative.map do |citizen|
            ending_string = "#{citizen.initiatives[0].name} : #{citizen.initiatives[0].description}"
            starting_string = "#{citizen.name} (HLTH: #{citizen.health.to_s}/STR: #{citizen.strength.to_s})"
            (50-starting_string.length).times {ending_string = ending_string.insert(0, ' ')}
            starting_string + ending_string
        end
    end

    # this method returns all the citizen names
    def self.getCitizenNames
        Citizen.all.map {|citizen| citizen.name}
    end

    # this method randomizes all the initiatives that all citizens believe in
    def self.randomizeInitiatives
        Advocacy.all.each do |advocacy| 
            advocacy.initiative = Initiative.all.sample
            advocacy.save
        end
    end
end