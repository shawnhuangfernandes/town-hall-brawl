require 'faker'

Citizen.delete_all
randomGenerator = Random.new

#types of initiatives
# - MAKE the <ANIMALS> PAY A '<NOUN>' tax!
# - MAKE <VERB-ing> illegal on <DAY OF THE WEEK>
# - 

15.times do
    Citizen.create(name: Faker::FunnyName.name, strength: randomGenerator.rand(1..5), health: randomGenerator.rand(5..15))
end

6.times do
    Initiative.create(name: "Initiative #{randomGenerator.rand(1..2000)}", description: "")
end