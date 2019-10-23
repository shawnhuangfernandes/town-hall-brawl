class Citizen < ActiveRecord::Base
    has_many :advocacies # relationship - a citizen has many advocacies
    has_many :initiatives, through: :advocacies # relationship - a citizen has many initiatives through advocacies
    
    ACTION_VERB = ["obliterated", "eviscerated", "eliminated", "absolutely mopped the floor with", "bamboozled",
                   "creamed", "wasted", "destroyed", "physically-vetoed", "pwned", "clobbered", "sliced n' diced",
                   "annihilated", "vaporized", "wrecked", "crushed", "slayed", "opened a can of whoop-@ss on", 
                   "thrashed", "whipped", "pulverized" , "blew up", "KABLOOIED", "KBLAMO'd", "totally just HONK HONK'd all over"]

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
        Citizen.all.each do |citizen|
            puts "#{citizen.name} (HLTH: #{citizen.health}/STR: #{citizen.strength}) supports #{citizen.initiatives[0].name} : #{citizen.initiatives[0].description}"
        end
    end

    def self.getCitizenNames
        Citizen.all.map {|citizen| citizen.name}
    end

    def self.doSomePolitics
        Advocacy.all.each do |advocacy| 
            advocacy.initiative = Initiative.all.sample
            advocacy.save
        end
    end
end