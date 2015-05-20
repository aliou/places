module Errors
  # Error thrown when a method from an STI is called on the parent class instead
  # of on a child class.
  class NotImplementedError < StandardError; end
end
