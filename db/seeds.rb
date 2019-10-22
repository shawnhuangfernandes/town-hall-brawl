require 'faker'

Citizen.delete_all
Initiative.delete_all

randomGenerator = Random.new

initiativeMessageArray = 
[
    "Make #{Faker::Name.first_name} the #{Faker::Creature::Animal.name} turn the music down!",
    "Make #{Faker::Verb.ing_form} illegal on Mondays!",
    "Subsidize #{Faker::Food.dish} stands to attract more #{Faker::Company.profession}s to our town!",
    "Increase surveillance on the #{Faker::Dessert.variety} cult!",
    "Update the swimming pool's safety board language to #{Faker::Nation.language}!",
    "Prevent #{Faker::Space.agency} from parking their #{Faker::Space.launch_vehicle} in my yard!",
    "Make it legal for me to drive my #{Faker::Construction.heavy_equipment} across the baseball field!",
    "#{Faker::ElectricalComponents.electromechanical}s aren't real. Erase them from the dictionary!"
]

def createInitiativeMessage
    initiativeMessageArray[randomGenerator(0...initiativeMessageArray.size)]
end

15.times do
    Citizen.create(name: Faker::FunnyName.name, strength: randomGenerator.rand(1..5), health: randomGenerator.rand(5..15))
end

6.times do
    Initiative.create(name: "Initiative #{randomGenerator.rand(1..2000)}", description: createInitiativeMessage)
end