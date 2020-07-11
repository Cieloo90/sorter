require 'sequel'
require 'pry'

DB = Sequel.connect('postgres://postgres:password@172.17.0.2:5432/sorter_db')


DB.create_table? :items do
  primary_key :id
  Text        :name
  Integer     :score, default: 0
  Integer     :compares_amount, default: 0
end

DB.create_table? :compares do
  primary_key :id
  Integer     :first_item_id
  Integer     :second_item_id
  Integer     :score
end

class Item < Sequel::Model(DB[:items])
  one_to_many :compares, key: :first_item_id

  def add_score 
    actual_score = self[:score]
    self.update score: actual_score + 1
    nil
  end

  def add_compares_amount
    actual_compares_amount = self[:compares_amount]
    self.update compares_amount: actual_compares_amount + 1
  end

  def self.non_compared_pair
    pairs = []
    ids = Item.all.map(&:id)
    ids.map do |id1|
       ids.map do |id2|
        next if id1 == id2
        if Compare.filter(first_item_id: id1, second_item_id: id2).last == nil 
          return [Item[id1], Item[id2]]
        end
      end
      return nil
    end
  end

end

class Compare < Sequel::Model(DB[:compares])
  many_to_one :items, key: :id
end

# Checkpoint.insert(
#   track_id: 1,
#   time: 209,
#   desc: 'spoken, spoooooken'
# )

binding.pry if ARGV[0] == 'repl'