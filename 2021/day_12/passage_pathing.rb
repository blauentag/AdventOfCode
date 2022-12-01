#!/usr/bin/env ruby



class Passages
  class Cave

    attr_accessor :next, :previous, :key, :data

    def initialize key, data
      self.key = key
			self.data = data
      self.next = nil
      self.previous = nil
		end
  end

MAX_LENGTH = 4

  attr_accessor :head, :tail, :length, :map

  def initialize
    self.head    = nil
    self.tail    = nil
    self.length  = 0
    self.map = Hash.new()
  end

  def get(key)
    cave = map[key]
    if cave
      previous =  cave.previous
      following = cave.next
      cave.previous = nil
      cave.next = self.head
      self.head = cave
      previous.next = following
      following.previous = previous if following
    else
      # lookup data
      self.push key, key
      cave = self.head
    end
    cave.data
  end

  def push(key, data)
    cave = Cave.new key, data
    self.map[key] = cave
    self.head&.previous = cave
    cave.next = self.head
    self.head = cave
    self.tail = cave if self.tail.nil?
    self.length += 1
    if MAX_LENGTH <= self.length
      pop
    end
  end

  def pop
    temp = self.tail
    self.tail = temp.previous
    self.tail.next = nil
    self.map.delete(temp.key)
    temp = nil
    self.length -= 1
  end

  def show
    current = self.head
    puts current
    while current.next
      puts current.next
      current = current.next
    end
  end
end
