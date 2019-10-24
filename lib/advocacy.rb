class Advocacy < ActiveRecord::Base
    belongs_to :citizen # relationship with Citizen
    belongs_to :initiative # relationship with Initiative

    # had to override the built in Active Record initiative getter
    def initiative
        Initiative.find(self.initiative_id)
    end

    # had to override the built in Active Record initiative setter
    def initiative=(initiative)
        self[:initiative_id] = initiative.id
    end
end