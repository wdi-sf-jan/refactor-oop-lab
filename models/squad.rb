class Squad
  def initialize params
    @id = params["id"]
    @name = params["name"]
    @mascot = params["mascot"]
  end

  attr_reader :id, :name, :mascot
  
  # should maintain a db connection
  def self.conn= connection
    @conn = connection
  end

  def self.conn
    @conn
  end

  # should return a list of squads
  def self.all
    @conn.exec("SELECT * FROM squads")
  end

  # should return a squad by id
  # or nil if not found
  def self.find id
    new @conn.exec('SELECT * FROM squads WHERE id = ($1)', [ id ] )[0]
  end

  def students
    Squad.conn.exec("SELECT * FROM students WHERE squad_id = ($1)", [id])
  end

  def save
    Squad.conn.exec('INSERT INTO squads (name, mascot) values ($1, $2)', [ name, mascot ] )
  end
end
