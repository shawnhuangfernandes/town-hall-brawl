require 'faker'

Citizen.delete_all # delete all existing citizen rows from the db
Initiative.delete_all # delete all existing initiative rows from the db

$final_array = []

$message_array = #create a new message array full of random initiative messages
[
    "Make #{Faker::Name.first_name} the #{Faker::Creature::Animal.name.downcase} turn the music down!",
    "Make #{Faker::Verb.ing_form.downcase} illegal on Mondays!",
    "Subsidize #{Faker::Food.dish.downcase} stands to attract more #{Faker::Company.profession.downcase}s to our town!",
    "Increase surveillance on the #{Faker::Dessert.variety} cult!",
    "Update the swimming pool's safety board language to #{Faker::Nation.language}!",
    "Prevent the #{Faker::Space.agency} from parking their #{Faker::Space.launch_vehicle} in my yard!",
    "Make it legal for me to drive my #{Faker::Construction.heavy_equipment.downcase} across the baseball field!",
    "#{Faker::ElectricalComponents.electromechanical}s aren't real. Erase them from the dictionary!"
]

3.times do
    $final_array << ["Initiative #{rand(1..2000)}", "Make #{Faker::Name.first_name} the #{Faker::Creature::Animal.name} turn the music down!"]
end

3.times do
    $final_array << ["Initiative #{rand(1..2000)}", "Make #{Faker::Verb.ing_form} illegal on Mondays!"]

end

3.times do
    $final_array << ["Initiative #{rand(1..2000)}", "Subsidize #{Faker::Food.dish} stands to attract more #{Faker::Company.profession}s to our town!"]
end

3.times do
    $final_array << ["Initiative #{rand(1..2000)}", "Increase surveillance on the #{Faker::Dessert.variety} cult!"]
end

3.times do
    $final_array << ["Initiative #{rand(1..2000)}", "Update the swimming pool's safety board language to #{Faker::Nation.language}!"]
end

3.times do
    $final_array << ["Initiative #{rand(1..2000)}", "Prevent the #{Faker::Space.agency} from parking their #{Faker::Space.launch_vehicle} in my yard!"]
end

3.times do
    $final_array << ["Initiative #{rand(1..2000)}", "Make it legal for me to drive my #{Faker::Construction.heavy_equipment} across the baseball field!"]
end

3.times do
    $final_array << ["Initiative #{rand(1..2000)}", "#{Faker::ElectricalComponents.electromechanical}s aren't real. Erase them from the dictionary!"]
end

# create
25.times do
    Citizen.create(name: Faker::FunnyName.name, strength: rand(1..5), health: rand(5..15))
end

15.times do
    selected_pair = $final_array.sample
    Initiative.create(name: selected_pair[0], description: selected_pair[1])
end

# associate each citizen with two random initiatives
Citizen.all do |citizen|
    citizen.supportTwoRandomInitiatives
end
