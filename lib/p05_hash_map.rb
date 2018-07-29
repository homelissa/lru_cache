require_relative 'p02_hashing'
require_relative 'p04_linked_list'

class HashMap
  include Enumerable
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    @store[bucket(key)].include?(key)
  end

  def set(key, val)
    if (self.get(key))
      @store[bucket(key)].update(key, val)
    else
      if (@count >= num_buckets)
        resize!
      end
      @count += 1
      @store[bucket(key)].append(key, val)
    end
  end

  def get(key)
    @store[bucket(key)].get(key)
  end

  def delete(key)
    @store[bucket(key)].remove(key)
    @count -= 1
  end

  def each
    @store.each do |linked_list|
      linked_list.each do |node|
        if (self.include?(node.key))
          yield [node.key, node.val]
        end
      end
    end
  end

  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    size = num_buckets * 2
    newMap = Array.new(size) { LinkedList.new }
    self.each do |key, v|
      newMap[key.hash % size].append(key, v)
    end
    @store= newMap
  end

  def bucket(key)
    key.hash % num_buckets
    # optional but useful; return the bucket corresponding to `key`
  end
end
