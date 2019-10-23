class Initiative < ActiveRecord::Base
    has_many :advocacies
    has_many :citizens, through: :advocacies
    
    def name_and_description
        "#{self.name} : #{self.description}"
    end
end