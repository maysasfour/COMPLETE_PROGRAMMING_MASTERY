# Solution 2 -- Spaceship Operator for a Version Class
class Version
  include Comparable
  attr_reader :major, :minor, :patch

  def initialize(major, minor, patch)
    @major, @minor, @patch = major, minor, patch
  end

  def <=>(other)
    [major, minor, patch] <=> [other.major, other.minor, other.patch]
  end

  def to_s
    "#{major}.#{minor}.#{patch}"
  end
end

v1 = Version.new(1, 2, 0)
v2 = Version.new(1, 3, 0)
v3 = Version.new(2, 0, 0)
v4 = Version.new(1, 9, 9)

puts "v1 < v2? #{v1 < v2}"
puts "v3 > v4? #{v3 > v4}"

versions = [Version.new(1, 2, 0), Version.new(1, 0, 0), Version.new(1, 10, 0)]
puts versions.sort.map(&:to_s).inspect
puts "(lexical string sort would wrongly put 1.10.0 before 1.2.0 -- this uses real numeric [major,minor,patch] comparison instead)"
