class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    return student
  end

  def self.all
    results = DB[:conn].execute("SELECT * FROM students") 
    results.map { |row| self.new_from_db(row) }
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students 
      WHERE name = ?
    SQL

    results = DB[:conn].execute(sql, name)
    self.new_from_db(results[0])
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.all_students_in_grade_X(grade)
    results = DB[:conn].execute("SELECT * FROM students WHERE grade = ?", grade)
    results.map { |row| self.new_from_db(row) }
  end

  def self.all_students_in_grade_9
    self.all_students_in_grade_X(9)
  end

  def self.students_below_12th_grade
    results = DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
    results.map { |row| self.new_from_db(row) }
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1)[0]
  end

  def self.first_X_students_in_grade_10(limit)
    results = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", limit)
    results.map { |row| self.new_from_db(row) }
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
