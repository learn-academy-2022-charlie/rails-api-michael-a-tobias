class Sighting < ApplicationRecord
    belongs_to :animal # foreign key - animal_id
end