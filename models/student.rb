class Student

  attr_reader :id
  attr_accessor :name, :age, :spirit_animal, :squad_id
  
  def initialize params, existing=false
    @name = params["name"]
    @age = params["age"]
    @spirit_animal = params["spirit_animal"]
    @squad_id = params["squad_id"]
    @existing = existing
  end


  def existing?
    @existing
  end

  # should maintain a db connection
  def self.conn= connection   #Setting connection
    @conn = connection
  end

  def self.conn #Getter to be able to call our connection
    @conn
  end

  # should return a list of squads
  def self.all
    @conn.exec("SELECT * FROM squads")
  end

  # should return a squad by id
  # or nil if not found
  def self.find id
    new @conn.exec('SELECT * FROM students WHERE id = ($1)', [ id ] )[0], true
  end

  def students
    Student.conn.exec("SELECT * FROM students WHERE squad_id = ($1)", [id])
  end

  def save
    if existing?
      Student.conn.exec('UPDATE students SET name=$1, age=$2, spirit_animal=$3 WHERE id = $4', [ name, age, spirit_animal, id][0])
    else
      Student.conn.exec('INSERT INTO students (name, age, spirit_animal, squad_id) VALUES ($1, $2, $3, $4)', [ name, age, spirit_animal, squad_id ] )
    end
  end

  def self.create params
    new(params).save
  end

  def destroy
    Student.conn.exec('DELETE FROM students WHERE squad_id = $1', [ id ] )
    Student.conn.exec('DELETE FROM squads WHERE id = $1', [ id ] )
  end

end
