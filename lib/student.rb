require 'pry'
class Student
  attr_accessor :id, :name, :grade
  @@all = []

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = "SELECT * from students";

    DB[:conn].execute(sql).each do |array|
      @@all << Student.new_from_db(array)
    end
    return @@all
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?";
    test = DB[:conn].execute(sql, name)
    student = Student.new_from_db(test[0])
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    array = []
    sql = "SELECT * FROM students WHERE grade <= 11"
    DB[:conn].execute(sql).each do |abc|
      array << Student.new_from_db(abc)
    end
    return array
  end

  def self.first_X_students_in_grade_10(x)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    DB[:conn].execute(sql, x)

  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    student = DB[:conn].execute(sql)
    Student.new_from_db(student[0])
  end

  def self.all_students_in_grade_X(x)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql, x)
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
