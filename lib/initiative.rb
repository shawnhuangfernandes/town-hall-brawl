class Initiative < ActiveRecord::Base
    has_many :advocacies # relationship with Advocacy
    has_many :citizens, through: :advocacies # relationship with Citizen
    
    # method that returns name and description of Initiative
    def name_and_description
        "#{self.name} : #{self.description}"
    end
end