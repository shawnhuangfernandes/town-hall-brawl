class Initiative < ActiveRecord::Base
    has_many :advocacies
    has_many :citizens, through: :advocacies
end