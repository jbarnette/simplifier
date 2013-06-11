require "simplifier"

describe Simplifier do
  before do
    @simplifier = Simplifier.new
  end

  it "can take initializer options" do
    s = Simplifier.new :foo => :bar
    assert_equal :bar, s.options[:foo]
  end

  it "raises when an object can't be simplified" do
    assert_raises Simplifier::Unknown do
      @simplifier.simplify Object.new
    end
  end

  it "simplifies nil to nil" do
    assert_nil @simplifier.simplify nil
  end

  it "simplifies false to false" do
    assert_same false, @simplifier.simplify(false)
  end

  it "simplifies true to true" do
    assert_same true, @simplifier.simplify(true)
  end

  it "simplifies Numerics to themselves" do
    assert_equal 42, @simplifier.simplify(42)
    assert_equal 4.2, @simplifier.simplify(4.2)
  end

  it "simplifies Symbols to Strings" do
    assert_equal "sym", @simplifier.simplify(:sym)
    assert_same @simplifier.simplify(:sym), @simplifier.simplify(:sym)
    assert @simplifier.simplify(:sym).frozen?
  end

  it "simplifies Strings to UTF-8" do
    assert_equal "foo", @simplifier.simplify("foo")
    refute_same "foo", @simplifier.simplify("foo")
  end

  it "normalizes line endings in Strings" do
    assert_equal "foo\n", @simplifier.simplify("foo\r\n")
    assert_equal "foo\n", @simplifier.simplify("foo\r")
  end

  it "doesn't mess with binary encoded Strings" do
    blob = "foo".encode Encoding::BINARY
    assert_same blob, @simplifier.simplify(blob)
  end

  it "simplifies Arrays to Arrays of simplified objects" do
    source   = [:foo, [:bar, :baz], :quux]
    expected = ["foo", ["bar", "baz"], "quux"]

    assert_equal expected, @simplifier.simplify(source)
  end

  it "simplifies Sets to Arrays of simplified objects" do
    set = Set.new [:foo, :bar, :baz]
    assert_equal %w(foo bar baz), @simplifier.simplify(set)
  end

  it "simplifies Hashes by simplifying keys and values" do
    source   = { :foo => { :bar => [:baz, :quux] } }
    expected = { "foo" => { "bar" => ["baz", "quux"] } }

    assert_equal expected, @simplifier.simplify(source)
  end

  it "simplifies Dates to ISO 8601 Strings" do
    assert_equal "1999-03-03", @simplifier.simplify(Date.parse("1999-03-03"))
  end

  it "simplifies Times to UTC ISO 8601 Strings" do
    now = Time.parse "1999-03-03 23:54:16 UTC"
    assert_equal "1999-03-03T23:54:16Z", @simplifier.simplify(now)
  end

  it "simplifiest DateTimes to UTC ISO 8601 Strings" do
    now = DateTime.parse "1999-03-03 23:54:16 UTC"
    assert_equal "1999-03-03T23:54:16Z", @simplifier.simplify(now)
  end
end
