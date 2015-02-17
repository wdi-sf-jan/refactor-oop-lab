class Squad
  # should maintain a db connection
  def self.conn= connection
    @conn = connection
  end

  # should return a list of squads
  def self.all
    @conn.exec("SELECT * FROM squads")
  end

  # should return a squad by id
  # or nil if not found
  def self.find id
    @conn.exec('SELECT * FROM squads WHERE id = ($1)', [ id ] )[0]
  end
end
