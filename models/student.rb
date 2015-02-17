require_relative './model'

class Student < Model
  attr_reader :id, :squad_id
  attr_accessor :name, :age, :spirit_animal

  def initialize params, existing=false
    @id = params["id"]
    @squad_id = params["squad_id"]
    @name = params["name"]
    @age = params["age"]
    @spirit_animal = params["spirit_animal"]
    @existing = existing
  end

  def self.table_name
    "students"
  end

  def save
    if existing?
      Student.conn.exec('UPDATE students SET name=$1, age=$2, spirit_animal=$3 WHERE id = $4', [ name, age, spirit_animal, id ] )
    else
      Student.conn.exec('INSERT INTO students (name, age, spirit_animal, squad_id) values ($1,$2,$3,$4)', [ name, age, spirit_animal, squad_id ] )
    end
  end

end
