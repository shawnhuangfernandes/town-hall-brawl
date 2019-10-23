class Citizen < ActiveRecord::Base
    has_many :advocacies # relationship - a citizen has many advocacies
    has_many :initiatives, through: :advocacies # relationship - a citizen has many initiatives through advocacies

    # creates two new advocacy associations linked to random initatives and assigns them to this citizen

    def self.Brawl()
        until Advocacy.all.map {|advocacy| advocacy.initiative.name}.uniq.size == 2 do # we only have two initiatives in play
            currentCitizen = Citizen.all.shuffle[0]
            conflictingCitizen = Citizen.all.detect do |otherCitizen|
                currentCitizen.initiatives != otherCitizen.initiatives
            end

            binding.pry

            if conflictingCitizen
                brawlSession(currentCitizen, conflictingCitizen)
            end
        end
    end

    def self.brawlSession(citizen1, citizen2)
        citizen1.health -= citizen2.strength
        citizen2.health -= citizen1.strength
        citizen1.save
        citizen2.save

        if (citizen1.health > 0 && citizen2.health <= 0)
            destroy(citizen2.id)
        elsif (citizen1.health <= 0 && citizen2.health > 0)
            destroy(citizen1.id)
        elsif (citizen1.health <= 0 && citizen2.health <= 0)
            destroy(citizen1.id)
            destroy(citizen2.id)
        end # neither citizens destroyed each other
    end

end