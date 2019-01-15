require 'pry'
class Student
  attr_accessor :id, :name, :grade

  @@all =[]

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new()
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    return student


  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).each do |row|
      @@all<< Student.new_from_db(row)

    end
    return @@all


  end


  def self.all_students_in_grade_9

    sql = <<-SQL
      SELECT * FROM students WHERE grade = 9
    SQL
     return DB[:conn].execute(sql)

  end


  def self.students_below_12th_grade
    array = []
    sql = <<-SQL
      SELECT * FROM students WHERE grade <= 11
    SQL
    DB[:conn].execute(sql).each do |row|
      array<< Student.new_from_db(row)
    end
    return array
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL
    return DB[:conn].execute(sql,x)

  end
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL
    return Student.new_from_db(DB[:conn].execute(sql)[0])

  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    return DB[:conn].execute(sql,x)
  end


  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    row = DB[:conn].execute(sql, name)[0]
    Student.new_from_db(row)




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
