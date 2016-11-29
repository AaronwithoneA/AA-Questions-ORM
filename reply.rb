require_relative 'question'
require_relative 'questions_database'
require_relative 'user'


class Reply
  attr_accessor :question_id, :parent_id, :user_id, :body

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM replies
      WHERE id = ?
    SQL
    Reply.new(reply.first)
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def self.find_by_user_id(user_id)
    replies_data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT *
      FROM replies
      WHERE user_id = ?
    SQL

    replies_data.map { |reply_data| Reply.new(reply_data) }
  end

  def self.find_by_question_id(question_id)
    questions_data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT *
      FROM replies
      WHERE question_id = ?
    SQL

    questions_data.map { |question_data| Reply.new(question_data) }
  end

  def author
    author = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
      SELECT *
      FROM users
      WHERE id = ?
    SQL

    User.new(author.first)
  end

  def question
    question = QuestionsDatabase.instance.execute(<<-SQL, @question_id)
      SELECT *
      FROM questions
      WHERE id = ?
    SQL

    Question.new(question.first)
  end

  def parent_reply
    raise "reply has no parent" unless @parent_id

    parent = QuestionsDatabase.instance.execute(<<-SQL, @parent_id)
      SELECT *
      FROM replies
      WHERE id = ?
    SQL

    Reply.new(parent.first)
  end

  def child_replies
    children = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT *
      FROM replies
      WHERE parent_id = ?
    SQL

    children.map { |child| Reply.new(child) }
  end

end
