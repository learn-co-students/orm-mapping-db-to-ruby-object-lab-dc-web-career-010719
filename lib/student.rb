require 'pry'

class Student
  attr_accessor :id, :name, :grade



  def self.new_from_db(row)
    new_stud = Student.new
    new_stud.id = row[0]
    new_stud.name = row[1]
    new_stud.grade = row[2]
    new_stud
  end

  def self.all_students_in_grade_9
    # retrieve all the rows from the "Students" database
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 9
    SQL
    # remember each row should be a new instance of the Student class
    new_stud_array = DB[:conn].execute(sql)
    new_stud_array.each do |row|
      Student.new_from_db(row)
    end
  end

    def self.first_X_students_in_grade_10(num)
    # retrieve all the rows from the "Students" database
      sql = <<-SQL
        SELECT * FROM students WHERE grade = 10 LIMIT ?
      SQL
      # remember each row should be a new instance of the Student class
      new_stud_array = DB[:conn].execute(sql, num)
      new_stud_array.each do |row|
        Student.new_from_db(row)
      end
    end

   def self.first_student_in_grade_10
     sql = <<-SQL
       SELECT * FROM students WHERE grade = 10 LIMIT 1
     SQL
     new_stud = DB[:conn].execute(sql)
     Student.new_from_db(new_stud[0])
   end

    def self.students_below_12th_grade
    # retrieve all the rows from the "Students" database
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL
    # remember each row should be a new instance of the Student class
    new_stud_array = DB[:conn].execute(sql)
    new_stud_array.map do |row|
      Student.new_from_db(row)
    end
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    new_stud_array = DB[:conn].execute(sql)
    new_stud_array.map do |row|
      Student.new_from_db(row)
    end
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    new_stud_array = DB[:conn].execute(sql, grade)
    new_stud_array.map do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    new_stud = DB[:conn].execute(sql, name)
    # return a new instance of the Student class
    self.new_from_db(new_stud[0])
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
