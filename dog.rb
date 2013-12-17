require 'mysql2'
require 'debugger'
 
class Dog
  attr_accessor :id, :name, :color
  @@db = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "dogs")

  def initialize(name, color)
    @name = name
    @color = color
  end

  def db
    @@db
  end

  def self.db
    @@db
  end

  def saved?
    !id.nil?
  end

  def unsaved?
    id.nil?
  end

  def mark_saved
    self.id = db.last_id if db.last_id > 0
  end

  def insert
    db.query("INSERT INTO dogs (name,color) 
      VALUES ('#{name}','#{color}')")
    mark_saved
  end

  def save
    if self.id.nil? 
      insert
    else
      update
    end
  end

  def update
    if unsaved?
      save
    else
     db.query("UPDATE dogs
      SET name = '#{name}', color = '#{color}'
      WHERE id = #{id}")
   end
  end

  

  def self.find(id)
    results = self.db.query("SELECT * 
      FROM dogs
      WHERE id = #{id}")
    dog = Dog.new(results.first["name"], results.first["color"])
    dog.id = id
    dog
  end

  def self.create_new_obj(rows)
    dogs = []
    rows.each do |dog|
      dogs << Dog.new(dog["name"],dog["color"])
      dogs.last.id = dog["id"]
    end
    dogs
  end

  def self.find_by_att(attribute, value)
    results = db.query("SELECT *
      FROM dogs
      WHERE name = '#{value}'")
    debugger
    self.create_new_obj(results)
  end

  def self.delete(id)
    results = db.query("DELETE FROM dogs
      WHERE id = #{id}")
  end

 

end
 
# dog = Dog.find(1)
# debugger
# puts 'hi'
 
  # color, name, id
  # db
  # find_by_att
  # find
  # insert
  # update
  # delete/destroy
 
  # refactorings?
  # new_from_db?
  # saved?
  # save! (a smart method that knows the right thing to do)
  # unsaved?
  # mark_saved!
  # ==
  # inspect
  # reload
  # attributes