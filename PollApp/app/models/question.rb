class Question < ActiveRecord::Base

  validates :question_text, :poll_id, presence: true

  has_many :answer_choices,
    class_name: :AnswerChoice,
    primary_key: :id,
    foreign_key: :question_id


  belongs_to :poll,
    class_name: :Poll,
    primary_key: :id,
    foreign_key: :poll_id

  has_many :responses,
    through: :answer_choices,
    source: :responses

  def results
    responses_count = self.answer_choices
    .select("answer_choices.*, COUNT(responses.id)  AS response_count")
    .joins("LEFT OUTER JOIN responses on responses.answer_choice_id = answer_choices.id")
    .group("answer_choices.id")

    # p responses_count

    hash = Hash.new(0)
    responses_count.each do |response|
      hash[response.choice] = response.response_count
    end

    # self.answer_choices.includes(:responses).each do |choice|
    #   hash[choice.choice] = choice.responses.count
    # end

    # hash = Hash.new { |hash, key| hash[key] = 0 }
    # responds.each do |result|
    #   choice = AnswerChoice.where(id: result.answer_choice_id).pluck(:choice)
    #   hash[choice[0]] += 1
    # end

    # p hash
    hash

  end
end
