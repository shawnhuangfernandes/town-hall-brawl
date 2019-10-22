class Citizen < ActiveRecord::Base
    has_many :advocacies
    has_many :initiatives, through: :advocacies

    def supportTwoRandomInitiatives

    end
end