require 'faker'

Citizen.delete_all # delete all existing citizen rows from the db
Initiative.delete_all # delete all existing initiative rows from the db

$final_array = []

def createInitiativeVariations(numberOf)
    numberOf.times do
        $final_array << ["Initiative #{rand(1..2000)}", "Make #{Faker::Name.first_name} the #{Faker::Creature::Animal.name} turn the music down!"]
        $final_array << ["Initiative #{rand(1..2000)}", "Make #{Faker::Verb.ing_form} illegal on Mondays!"]
        $final_array << ["Initiative #{rand(1..2000)}", "Subsidize #{Faker::Food.dish} stands to attract more #{Faker::Company.profession}s to our town!"]
        $final_array << ["Initiative #{rand(1..2000)}", "Increase surveillance on the #{Faker::Dessert.variety} cult!"]
        $final_array << ["Initiative #{rand(1..2000)}", "Update the swimming pool's safety board language to #{Faker::Nation.language}!"]
        $final_array << ["Initiative #{rand(1..2000)}", "Prevent the #{Faker::Space.agency} from parking their #{Faker::Space.launch_vehicle} in my yard!"]
        $final_array << ["Initiative #{rand(1..2000)}", "Make it legal for me to drive my #{Faker::Construction.heavy_equipment} across the baseball field!"]
        $final_array << ["Initiative #{rand(1..2000)}", "#{Faker::ElectricalComponents.electromechanical}s aren't real. Erase them from the dictionary!"]
        $final_array << ["Initiative #{rand(1..2000)}", "Genetically clone #{Faker::Science.scientist} and send them to #{Faker::Space.planet}!"]
        $final_array << ["Initiative #{rand(1..2000)}", "Promote Salty Joe to  #{Faker::Military.air_force_rank} and send him out to #{Faker::Space.star}!"]
        $final_array << ["Initiative #{rand(1..2000)}", "#{Faker::Books::Lovecraft.fhtagn}!"]
        $final_array << ["Initiative #{rand(1..2000)}", "Reclaim the #{Faker::Games::Zelda.item} from those pesky #{Faker::Company.profession}s in #{Faker::Games::Zelda.location}!"]
        $final_array << ["Initiative #{rand(1..2000)}", "Award #{1..400000} points to #{Faker::Movies::HarryPotter.house}!"]

    end
end

def createCitizens(numberOf)
    numberOf.times do
        Citizen.create(name: Faker::FunnyName.name, strength: rand(1..25), health: rand(15..100))
    end

    Citizen.all.each do |citizen|
        Advocacy.create(citizen: citizen, initiative: Initiative.all.sample)
    end
end

def createInitiativesFromTypes(numberOf)
    numberOf.times do
        selected_pair = $final_array.sample
        Initiative.create(name: selected_pair[0], description: selected_pair[1])
    end
end

createInitiativeVariations(3)
createInitiativesFromTypes(10)
createCitizens(15)



