# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



User.destroy_all
users = []
100.times do
  user = User.create!(user_name: Faker::Name.name)
  users << user
end

Poll.destroy_all
polls = []
30.times do
  poll = Poll.create!(title: Faker::Company.buzzword, user_id: users.sample.id)
  polls << poll
end

Question.destroy_all
questions = []
200.times do
  text = Faker::ChuckNorris.fact[0...-1] + "?"
  question = Question.create!(question_text: text, poll_id: polls.sample.id)
  questions << question
end

AnswerChoice.destroy_all
choices = []
questions.each do |question|
  4.times do
    choice = AnswerChoice.create!(choice: Faker::FamilyGuy.quote, question_id: question.id)
    choices << choice
  end
end

Response.destroy_all
choices.each do |el|
  2.times do
    begin
      response = Response.create!(answer_choice_id: el.id, user_id: users.sample.id)
    rescue
      retry
    end
  end
end
