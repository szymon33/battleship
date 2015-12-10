require "spec_helper"
require "ship"

describe Ship do
  let(:matrix_size) { 10 }
  let(:sample_matrix) {  Array.new(10){ Array.new(matrix_size, false) }}
  let(:ship) { Ship.new(sample_matrix, 3) }

  it "is valid" do
    expect(ship).to be_kind_of(Ship)
  end

  it "has size" do
    expect(ship.instance_variable_get(:@xsize)).to eql(3)
  end

  it "has location array" do
    expect(ship.instance_variable_get(:@location)).to be_kind_of(Array)
  end

  it "has matrix array" do
    expect(ship.instance_variable_get(:@matrix)).to eql(sample_matrix)
  end

  it "setup location with random first position" do

  end

  describe "#save_location" do
    it "save coordinates to location" do
      expect{ship.send(:save_location, [2, 3])}.to change{
        ship.location
      }.to([[2 ,3]])      
    end

    it "set matrix with coordinates" do
      expect{ship.send(:save_location, [2, 3])}.to change{
        ship.instance_variable_get(:@matrix)[2][3]
      }.from(false).to(true)      
    end

    describe "calculates mask" do
      it "scenario 1 (normal)" do
        expect(ship.send(:save_location, [1, 1])).to eql([[0, 1], [1, 0], [1, 2], [2, 1]])
      end

      it "scenario 1 (corner A)" do
        expect(ship.send(:save_location, [0, 0])).to eql([[0, 1], [1, 0]])
      end

      it "scenario 1 (corner B)" do
        expect(ship.send(:save_location, [matrix_size-1, matrix_size-1])).to eql([[8, 9], [9, 8]])
      end
    end
  end

  describe "#build" do
    it "is valid" do
      expect(ship).to respond_to(:build)
    end
    
    it "makes ship array" do
      expect(ship.build.location).to be_kind_of(Array)
    end

    it "makes ship in specific size" do
      expect(ship.build.location.size).to eql(3)
    end

    it "makes another ship" do
      other = Ship.new(sample_matrix, 5).build
      expect(other.location.size).to eql(5)
    end    

    it "makes ship location with coordinates" do
      expect(ship.build.location.flatten.size).to eql(6)
    end
  end

  describe "#clean" do
    it "returns empty array when no mask" do
      expect(ship.send(:clean,[[3,4]])).to be_kind_of(Array)
      expect(ship.send(:clean,[])).to be_empty
    end

    it "returns passed item" do
      expect(
        ship.send(:clean, [[3,4]])
      ).to eql [[3,4]]
    end

    it "compacts" do
      expect(
        ship.send(:clean, [nil, [3,4], nil])
      ).to eql [[3,4]]      
    end

    describe "cleans with some specific conditions" do
      it "when in conflict with matrix" do
        # I leave some extra here for let you see my approche
        sample_matrix[9][8] = true
        expect(sample_matrix[0][1]).to be_falsey
        expect(sample_matrix[9][8]).to be_truthy
        expect(
          ship.send(:clean, [[0, 1], [9, 8]])
        ).to eql [[0, 1]]
      end
    end
  end
end
