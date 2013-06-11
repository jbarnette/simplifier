require "set"
require "time"

# Public: Reduce Ruby objects to a more primitive representation.
class Simplifier

  # Public: Raised when an object is simplified twice in one call.
  class Circular < RuntimeError
    def initialize(object)
      super "Circular reference to #{object.class.name} #{object.inspect}"
    end
  end

  # Public: Raised when an object can't be simplified.
  class Unknown < RuntimeError
    def initialize(object)
      super "Can't simplify #{object.class.name} #{object.inspect}"
    end
  end

  # Public: Get a Hash of Symbol-keyed options.
  attr_reader :options

  # Internal: A Hash cache of String representations of Symbols.
  attr_reader :symbols

  # Public: Create a new instance.
  def initialize(options = nil)
    @options = options || {}
    @symbols = Hash.new { |h, k| h[k] = k.to_s.freeze }
  end

  # Internal.
  def simplify(object)
    case object
    when Array, Set
      object.map { |o| simplify o }

    when DateTime
      simplify object.to_time

    when Date
      object.iso8601

    when Hash
      {}.tap do |hash|
        object.each do |key, value|
          hash[simplify key] = simplify value
        end
      end

    when NilClass
      object

    when Numeric
      object

    when String
      return object if object.encoding == Encoding::BINARY

      object.encode Encoding::UTF_8,
        :invalid => :replace, :undef => :replace, :universal_newline => true

    when Symbol
      symbols[object]

    when Time
      object.utc.iso8601

    when TrueClass, FalseClass
      object

    else
      raise Unknown, object
    end
  end
end
