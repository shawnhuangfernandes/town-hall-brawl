class Citizen < ActiveRecord::Base
    has_many :advocacies
    has_many :initiatives, through: :advocacies

    def supportTwoRandomInitiatives

        list_of_ids = Initiative.all.map {|initiative| initiative.id}

        init_id1 = list_of_ids.sample
        

        Advocacy.new(self, Initiative.find)
    
    end
end