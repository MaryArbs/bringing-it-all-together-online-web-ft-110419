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
  new_dog = self.new(id, name, grade)
  new_dog.id = row[0]
  new_dog.name =  row[1]
  new_dog.breed = row[2]
  new_dog  # return the newly created instance
end

end
