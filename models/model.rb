class Model
  def existing?
    @existing
  end
  
  # should maintain a db connection
  def self.conn= connection
    @conn = connection
  end

  def self.conn
    @conn
  end

  def self.all
    @conn.exec("SELECT * FROM #{self.table_name}")
  end

  def self.find id
    new @conn.exec("SELECT * FROM #{self.table_name}  WHERE id = ($1)", [ id ] )[0], true
  end

  def self.create params
    new(params).save
  end

end
