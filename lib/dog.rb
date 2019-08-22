class Dog

  attr_accessor :id, :name, :breed

  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE dogs"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      #update?
    else
      sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      self.id = DB[:conn].execute("SELECT last_insert_rowid()")[0][0]
    end
    self
  end

  def self.create(name:, breed:)
    dog = Dog.new(name: name, breed: breed)
    dog.save
  end

  def self.new_from_db(row)
    dog = Dog.new(id: row[0], name: row[1], breed: row[2])
  end

  def self.find_by_id(id)
    sql = <<-SQL
    SELECT *
    FROM dogs
    WHERE id = ?
    SQL
    row = DB[:conn].execute(sql, id)[0]
    self.new_from_db(row)
  end

  def self.find_or_create_by(name:, breed:)
    dog =  DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
    if !dog.empty?
      dog_data = dog[0]
      dog = Dog.new(id: dog_data[0], name: dog_data[1], breed: dog_data[2])
    else
      Dog.create(name: row[1], breed: row[2])
    end
  end

#   def self.find_or_create_by(name:, album:)
#   song = DB[:conn].execute("SELECT * FROM songs WHERE name = ? AND album = ?", name, album)
#   if !song.empty?
#     song_data = song[0]
#     song = Song.new(song_data[0], song_data[1], song_data[2])
#   else
#     song = self.create(name: name, album: album)
#   end
#   song
# end




end
