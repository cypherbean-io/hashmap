class HashMap
  def initialize(capacity = 16, load_factor = 0.75)
    @capacity = capacity
    @load_factor = load_factor
    @buckets = Array.new(@capacity) { [] }
    @size = 0
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
    hash_code
  end

  def set(key, value)
    resize
    index = hash(key) % @capacity
    raise IndexError if index.negative? || index >= @buckets.length

    bucket = @buckets[index]
    bucket.each do |pair|
      if pair[0] == key
        pair[1] = value
        return
      end
    end
    bucket << [key, value]
    @size += 1
  end
  
  def get(key)
    index = hash(key) % @capacity
    raise IndexError if index.negative? || index >= @buckets.length

    bucket = @buckets[index]
    bucket.each do |pair|
      return pair[1] if pair[0] == key
    end
    nil
  end

  def has?(key)
    !get(key).nil?
  end

  def remove(key)
    index = hash(key) % @capacity
    raise IndexError if index.negative? || index >= @buckets.length

    bucket = @buckets[index]
    bucket.each_with_index do |pair, i|
      if pair[0] == key
        bucket.delete_at(i)
        @size -= 1
        return
      end
    end
  end

  def length
    @size
  end

  def clear
    @buckets = Array.new(@capacity) { [] }
    @size = 0
  end

  def keys
    @buckets.flat_map { |bucket| bucket.map { |pair| pair[0] } }
  end

  def values
    @buckets.flat_map { |bucket| bucket.map { |pair| pair[1] } }
  end

  def entries
    @buckets.flat_map { |bucket| bucket.map { |key, value| [key, value] } }
  end

  private

  def resize
    if @size >= @capacity * @load_factor
      new_capacity = @capacity * 2
      new_buckets = Array.new(new_capacity) { [] }

      @buckets.each do |bucket|
        bucket.each do |key, value|
          new_index = hash(key) % new_capacity
          new_buckets[new_index] << [key, value]
        end
      end
      @capacity = new_capacity
      @buckets = new_buckets
    end
  end
end