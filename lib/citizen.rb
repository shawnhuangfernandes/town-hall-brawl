class Citizen < ActiveRecord::Base
    has_many :advocacies # relationship - a citizen has many advocacies
    has_many :initiatives, through: :advocacies # relationship - a citizen has many initiatives through advocacies

    # creates two new advocacy associations linked to random initatives and assigns them to this citizen
    def supportTwoRandomInitiatives
        list_of_ids = Initiative.all.map {|initiative| initiative.id} # get a list of ids for all the initiatives

        init_id1 = list_of_ids.sample # get a random id for the first initative to assign
        init_id2 = init_id1 # set the second id to the first id (to pass the condition below)
        
        # until the second initiative is not the same (id) as the first initiative
        until init_id2 != init_id1 do 
            init_id2 = list_of_ids.sample # randomize the second initiative
        end

        # take two associations (one for both initiatives and this citizen)
        Advocacy.create(citizen: self, initiative: Initiative.find(init_id1))
        Advocacy.create(citizen: self, initiative: Initiative.find(init_id2))  
    end

    def self.Brawl(citizen_array)
        if Advocacy.all.map {|advocacy| advocacy.initiative.name}.uniq.size == 2 # we only have two initiatives in play
            return citizen_array
        else 
            citizens_in_brawl = citizen_array.shuffle
            binding.pry
        end# else, lets make people fight
            # citizens_in_brawl = citizen_array.shuffle # lets shuffle the citizens who are alive
            # citizen_of_focus = citizens_in_brawl[0] # lets grab the first citizen
            # citizens_in_brawl.each do |citizen| # make the citizen citizen_of_focus fight the first citizen with dissimilar values
            #     if (citizen.initiatives == citizen[0].initiatives)
            #         binding.pry
            #     end
            # end
    end
end