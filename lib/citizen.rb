class Citizen < ActiveRecord::Base
    has_many :advocacies # relationship - a citizen has many advocacies
    has_many :initiatives, through: :advocacies # relationship - a citizen has many initiatives through advocacies
    
    ACTION_VERB = ["obliterated", "eviscerated", "eliminated", "absolutely mopped the floor with", "bamboozled",
                   "creamed", "wasted", "destroyed", "physically-vetoed", "pwned", "clobbered", "sliced n' diced",
                   "annihilated", "vaporized", "wrecked", "crushed", "slayed", "opened a can of whoop-@ss on", 
                   "thrashed", "whipped", "pulverized" , "blew up", "KABLOOIED", "KABLAMO'd", "totally just HONK HONK'd all over"]

    def self.brawl()
        until Advocacy.all.map {|advocacy| advocacy.initiative.name}.uniq.size <= 1 do # we only have one initiatives in play
            currentCitizen = Citizen.all.shuffle[0]
            conflictingCitizen = Citizen.all.detect do |otherCitizen|
                currentCitizen.initiatives != otherCitizen.initiatives
            end

            if conflictingCitizen
                brawlSession(currentCitizen, conflictingCitizen)
            end
        end

        if (Citizen.all.count == 0)
            puts "Well, this is awkward... looks like everyone #{ACTION_VERB.sample} each other. Nobody's left!"
        else
            puts "The initative that's going to pass is #{Citizen.all.first.initiatives[0].name} : #{Citizen.all.first.initiatives[0].description}"
            Citizen.all.first.initiatives[0].name.split[1]
        end
    end

    def self.brawlSession(citizen1, citizen2)
        until citizen1.health <= 0 || citizen2.health <= 0
        citizen1.health -= rand(1..citizen2.strength)
        citizen2.health -= rand(1..citizen1.strength)
        citizen1.save
        citizen2.save
        end

        if (citizen1.health > 0 && citizen2.health <= 0)
            destroyCitizen(citizen2)
            puts "#{citizen1.name} #{ACTION_VERB.sample} #{citizen2.name}!"
        elsif (citizen1.health <= 0 && citizen2.health > 0)
            destroyCitizen(citizen1)
            puts "#{citizen2.name} #{ACTION_VERB.sample} #{citizen1.name}!"
        elsif (citizen1.health <= 0 && citizen2.health <= 0)
            destroyCitizen(citizen1)
            destroyCitizen(citizen2)
            puts "#{citizen1.name} and #{citizen2.name} #{ACTION_VERB.sample} each other!"
        end
    end

    def self.destroyCitizen(citizen)
        Advocacy.destroy(citizen.advocacies[0].id)
        destroy(citizen.id)
    end

    def self.displayCitizenBeliefs   
        citizens_grouped_by_initiative = Citizen.all.sort_by {|citizen| citizen.initiatives[0].name}

        citizens_grouped_by_initiative.each do |citizen|
            first_term_length = "#{citizen.name} (HLTH: #{citizen.health}/STR: #{citizen.strength}) is in favor of".length
            print "#{ColorizedString.new(citizen.name).green} (HLTH: #{ColorizedString.new(citizen.health.to_s).blue}/STR: #{ColorizedString.new(citizen.strength.to_s).red})"
            (55-first_term_length).times do
                print " "
            end

            puts "#{ColorizedString.new(citizen.initiatives[0].name).light_green} : #{citizen.initiatives[0].description}"
        end
    end

    def self.returnCitizenBeliefs
        citizens_grouped_by_initiative = Citizen.all.sort_by {|citizen| citizen.initiatives[0].name}
        
        citizens_grouped_by_initiative.map do |citizen|
            ending_string = "#{citizen.initiatives[0].name} : #{citizen.initiatives[0].description}"
            starting_string = "#{citizen.name} (HLTH: #{citizen.health.to_s}/STR: #{citizen.strength.to_s})"
            (50-starting_string.length).times {ending_string = ending_string.insert(0, ' ')}
            starting_string + ending_string
        end
    end

    def self.getCitizenNames
        Citizen.all.map {|citizen| citizen.name}
    end

    def self.randomizeInitiatives
        Advocacy.all.each do |advocacy| 
            advocacy.initiative = Initiative.all.sample
            advocacy.save
        end
    end
end