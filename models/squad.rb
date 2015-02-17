require_relative './model'

class Squad < Model
  attr_reader :id
  attr_accessor :name, :mascot
  
  def initialize params, existing=false
    @id = params["id"]
    @name = params["name"]
    @mascot = params["mascot"]
    @existing = existing
  end

  def self.table_name
    "squads"
  end

  def students
    Squad.conn.exec("SELECT * FROM students WHERE squad_id = ($1)", [id])
  end

  def save
    if existing?
      Squad.conn.exec('UPDATE squads SET name=$1, mascot=$2 WHERE id = $3', [ name, mascot, id ] )
    else
      Squad.conn.exec('INSERT INTO squads (name, mascot) values ($1, $2)', [ name, mascot ] )
    end
  end

end
