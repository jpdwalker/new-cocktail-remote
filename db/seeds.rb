# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Dose.destroy_all
# Ingredient.destroy_all
# Cocktail.destroy_all

# puts "creating three ingredients"
# ingredient_one = Ingredient.create(name: "ice")
# ingredient_two = Ingredient.create(name: "mint leaves")
# ingredient_three = Ingredient.create(name: "lemon")

# ingredients = [ingredient_one, ingredient_two, ingredient_three]

# puts "creating cocktails and doses "
# 5.times do
#   cocktail = Cocktail.create!(name: Faker::Cannabis.cannabinoid )
#   5.times do
#     Dose.create!(
#       description: Faker::Cannabis.buzzword,
#       cocktail: cocktail,
#       ingredient: ingredients.sample
#     )
#   end
# end

# require 'open-uri'
# require 'json'

# Cocktail.destroy_all
# Dose.destroy_all
# Ingredient.destroy_all
# url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"

# ingredient_serialized = open(url).read
# ingredients = JSON.parse(ingredient_serialized)

# ingredients["drinks"].each do |ingredient|
#   Ingredient.create(name: ingredient["strIngredient1"])
# end

require 'json'
require 'open-uri'

puts 'Spilling cocktails...'
Cocktail.destroy_all
puts 'Burning ingredients...'
Ingredient.destroy_all
puts 'Deleting dose information...'
Dose.destroy_all
puts "OK... Filling database with cocktails"

amount = 30
# fetching cocktail seeds
querys = []
all_url = 'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail'
json = open(all_url).read
data = JSON.parse(json)
counter = 0
amount.times do
  querys << data['drinks'][counter]['strDrink']
  counter += 1
end

puts "Please be patient"
# creating cocktails
querys.each do |query|
  url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s="
  search = url + query
  json = open(search).read
  data = JSON.parse(json)
  cocktail = Cocktail.new(
    name: data['drinks'][0]['strDrink'],
  )
  cocktail.remote_photo_url = data['drinks'][0]['strDrinkThumb']
  cocktail.save
end

# creating ingredients
puts 'Filling database with ingredients'
url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
json = open(url).read
data = JSON.parse(json)
data['drinks'].each do |d|
  Ingredient.create(name: d['strIngredient1'])
end

# creating doses
puts "Assigning ingredients to cocktails"
Cocktail.all.each do |cocktail|
  url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=#{cocktail.name}"
  json = open(url).read
  data = JSON.parse(json)
  count = 1
  14.times do
    Dose.create(
      description: data['drinks'][0]["strMeasure#{count}"],
      ingredient: Ingredient.find_by(name: data['drinks'][0]["strIngredient#{count}"]),
      cocktail: cocktail
    )
    count += 1
  end
end
