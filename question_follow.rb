require_relative 'question'
require_relative 'questions_database'
require_relative 'user'


class QuestionFollow
  attr_accessor :follower_id, :question_id

  def self.find_by_id(id)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM question_follows
      WHERE id = ?
    SQL
    QuestionFollow.new(question_follow.first)
  end

  def initialize(options)
    @id = options['id']
    @follower_id = options['follower_id']
    @question_id = options['question_id']
  end

  def self.followers_for_question_id(question_id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT *
      FROM users
      JOIN question_follows
        ON question_follows.follower_id = users.id
      WHERE question_follows.question_id = ?
    SQL

    followers.map { |follower| User.new(follower) }
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT *
      FROM questions
      JOIN question_follows
        ON question_follows.question_id = questions.id
      WHERE question_follows.follower_id = ?
    SQL

    questions.map { |question| Question.new(question) }
  end

end
