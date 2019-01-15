require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    DB[:conn].execute("select * from students").map do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    student = DB[:conn].execute("select * from students where name = ?", name)
    Student.new_from_db(student[0])
  end

  def self.all_students_in_grade_9
    array = DB[:conn].execute("select * from students where grade = 9;")
    array.map { |info| Student.new_from_db(info) }
  end

  def self.students_below_12th_grade
    array = DB[:conn].execute("select * from students where grade < 12;")
    array.map { |info| Student.new_from_db(info) }
  end

  def self.first_X_students_in_grade_10(number)
    array = DB[:conn].execute("select * from students where grade = 10 limit ?", number)
    array.map { |info| Student.new_from_db(info) }
  end

  def self.first_student_in_grade_10
    array = DB[:conn].execute("select * from students where grade = 10 limit 1")
    array.map { |info| Student.new_from_db(info) }[0]
  end

  def self.all_students_in_grade_X(grade)
    array = DB[:conn].execute("select * from students where grade = ?", grade)
    array.map { |info| Student.new_from_db(info) }
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
