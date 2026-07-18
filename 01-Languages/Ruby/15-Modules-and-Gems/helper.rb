# A plain sibling file, loaded by example.rb via require_relative -- this
# demonstrates require_relative's core selling point: it resolves relative
# to THIS file's own location on disk, not the caller's current working
# directory, so `ruby example.rb` works identically whether run from this
# folder or from anywhere else in the repository.
module Helper
  def self.shout(msg)
    "#{msg.upcase}!"
  end
end
