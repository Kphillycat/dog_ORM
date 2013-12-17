require './dog'

describe Dog do
  context "database operations" do
    before(:each) do
      @dog = Dog.new.tap { |s| s.name = "Anything But Scott Oh Nevermind" }
    end

    #think about what you need to do to set up a database
    #and what should have the responsibility for doing that for these tests

    describe ".insert" do
      it "persists the student to the database" do
        @dog.should respond_to(:insert)
        @dog.insert.should eq(true)
      end
    end

    describe ".update" do
      it "updates the student in the database" do
        @dog.insert
        @dog.name = "Catherine"
        @dog.update.should eq(true)
      end
    end

    describe ".save" do
      it "chooses the right thing on first save" do
        @dog.should_receive(:insert)
        @dog.save
      end
      it "chooses the right thing after saving" do
        @dog.save
        @dog.name = "Steven"
        @dog.should_receive(:update)
        @dog.save
      end
    end

    #bonus 1:  prove it!
    describe "::find" do
      it "loads the student from the database" do
        @dog.save
        loaded = Dog.find(@dog.id)
        loaded.name.should eq(@dog.name)
        loaded.id.should eq(@dog.id)
        @dog.name = "new name"
        @dog.save
        updated = Dog.find(@dog.id)
        updated.name.should eq(@dog.name)
      end

    end

    #bonus 2: use before(:each) and after(:each) to create your database
    #and set it to a default state for each test

    #bonus 3: extract the code you used in bonus 2 to a
    #new class that the test can reference to create and destroy databases
  end
end


describe "Dog" do

  before(:each) do
    # Dog.reset_all
  end

  it "can be instantiated" do
    Dog.new.should be_an_instance_of(Dog)
  end

  describe "dog properties" do
    let(:dog) { Dog.new }

    context 'creating a new dog' do
      it 'has properties based on an attributes hash' do
        Dog.attributes.each do |attribute|
          dog.send("#{attribute}=", "Testing #{attribute}")
        end
        dog.save

        test_dog = Dog.find(dog.id)

        Dog.attributes.each do |attribute|
          test_dog.send(attribute).should eq("Testing #{attribute}")
        end
      end
    end

    context 'update a dog' do
      it 'has properties based on an attributes hash' do
        Dog.attributes.each do |attribute|
          dog.send("#{attribute}=", "Original #{attribute}")
        end
        dog.save

        Dog.attributes.each do |attribute|
          dog.send("#{attribute}=", "Updated #{attribute}")
        end
        dog.save

        test_dog = Dog.find(dog.id)

        Dog.attributes.each do |attribute|
          test_dog.send(attribute).should eq("Updated #{attribute}")
        end
      end
    end
  end

  #BONUS ROUND! Implement an ID system
  context "with an ID" do

    let(:dog) { Dog.new }

    before(:each) do
    end


    it "has an ID" do
      dog.should respond_to(:id)
    end

    it "doesn't allow ID to be changed" do
      dog.should_not respond_to(:id=)
    end

    it "auto-assigns an id" do
      dog.name = "Becky"
      dog.save
      dog.id.should eq(1)

      d2 = Dog.new
      d2.save
      d2.id.should eq(2)
    end

    describe "::delete" do

      it "can be deleted" do

      end

    end
  end

end

describe "Dog", "finders" do
  let(:dog){Dog.new}
  
  before(:each) do
  end

  it 'has a finder for every attribute' do
    Dog.attributes.each do |attribute|
      Dog.should respond_to("find_by_#{attribute}")
    end
  end

  it 'finds a student by every attribute' do
    # create a student with every attribute value
    Dog.attributes.each do |attribute|
      student.send("#{attribute}=", "Find #{attribute}")
    end
    student.save
    
    Dog.attributes.each do |attribute|
      Dog.send("find_by_#{attribute}", "Find #{attribute}").first.should eq(dog)
    end
  end
end
