class Response < ActiveRecord::Base

  validates :user_id, :answer_choice_id, presence: true
  validate :respondent_already_answered?
  validate :responder_same_as_poll_author?

  belongs_to :answer_choice,
    class_name: :AnswerChoice,
    primary_key: :id,
    foreign_key: :answer_choice_id

  belongs_to :respondent,
    class_name: :User,
    primary_key: :id,
    foreign_key: :user_id

  has_one :question,
    through: :answer_choice,
    source: :question

  def sibling_responses
    question = self.question
    question.responses.where.not(id: self.id)
  end

  private

  def respondent_already_answered?
    if sibling_responses.exists?(user_id: self.user_id)
      errors[:user_id] << "Can't respond more than once"
    end
  end

  def responder_same_as_poll_author?
    if self.question.poll.user_id == self.user_id
      errors[:user_id] << "Can't respond to own poll"
    end
  end
end
