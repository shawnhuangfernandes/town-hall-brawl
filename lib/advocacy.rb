class Advocacy < ActiveRecord::Base
    belongs_to :citizen
    belongs_to :initiative
end