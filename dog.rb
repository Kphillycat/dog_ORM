require 'mysql2'
require 'debugger'
 
class Dog
  attr_accessor :name, :color
  attr_reader :id
  @@db = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "dogs")

  def initialize
    @name
    @color
  end

  def db
    @@db
  end

  def self.db
    @@db
  end

  def saved?
    !self.id.nil?
  end

  def unsaved?
    self.id.nil?
  end

  def mark_saved
    self.id = db.last_id if db.last_id > 0
  end

  def insert
    db.query("INSERT INTO dogs (name,color) 
      VALUES ('#{name}','#{color}')")
    mark_saved
    saved?
  end

  def update
    if unsaved?
      save
    else
     db.query("UPDATE dogs
      SET name = '#{name}', color = '#{color}'
      WHERE id = #{id}")
    end
    saved?
  end

  def save
    if self.id.nil? 
      insert
    else
      update
    end
  end

  def self.create_new_obj(id, row)
    dog = Dog.new
    dog.name = row.first["name"]
    dog.color = row.first["color"]
    debugger
    dog.id = id
    dog
  end

  def self.find(id)
    results = self.db.query("SELECT * 
      FROM dogs
      WHERE id = #{id}")
    self.create_new_obj(id, results)
 end

  def self.create_new_objects(rows)
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
    self.create_new_objects(results)
  end

  def self.delete(id)
    results = db.query("DELETE FROM dogs
      WHERE id = #{id}")
  end

  def self.attributes
    ["name","color"]
  end

  private

  def id=(id)
    @id = id
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