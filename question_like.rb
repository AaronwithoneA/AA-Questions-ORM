require_relative 'question'
require_relative 'questions_database'
require_relative 'user'

class QuestionLike
  attr_accessor :liker_id, :question_id

  def self.find_by_id(id)
    question_like = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM question_likes
      WHERE id = ?
    SQL
    QuestionLike.new(question_like.first)
  end

  def initialize(options)
    @id = options['id']
    @liker_id = options['liker_id']
    @question_id = options['question_id']
  end

end
