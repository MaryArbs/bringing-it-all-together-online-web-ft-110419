class Dog
  attr_accessor :id, :name, :breed

  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
    self.id ||= nil
  end

  def self.create_table
   sql = <<-SQL
     CREATE TABLE IF NOT EXISTS dogs (
       id INTEGER PRIMARY KEY,
       name TEXT,
       breed TEXT
       )
   SQL

   DB[:conn].execute(sql)
 end

 def self.drop_table
  sql = "DROP TABLE IF EXISTS dogs"
  DB[:conn].execute(sql)
 end

  def save
   sql = <<-SQL
   INSERT INTO dogs (name, breed) VALUES (?, ?)
   SQL

    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end


  def self.create(attributes)
    dog = Dog.new(attributes)
    dog.save
    dog
  end

  def self.new_from_db(row)
    attributes = {
         :id => row[0],
         :name => row[1],
         :breed => row[2]
       }
       self.new(attributes) # return the newly created instance
end

end
