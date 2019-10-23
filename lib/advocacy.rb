class Advocacy < ActiveRecord::Base
    belongs_to :citizen
    belongs_to :initiative

    def initiative
        Initiative.find(self.initiative_id)
    end

    def initiative=(initiative)
        self[:initiative_id] = initiative.id
    end
end