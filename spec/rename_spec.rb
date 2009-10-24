
require "pty"
require "expect"

RENAME = "bin/rename"

describe RENAME do

  it "should print its usage if it receives no arguments" do
    PTY.spawn("#{RENAME}") do |stdin, stdout, pid|
      stdin.expect(/(.*)Usage(.*)$/).should_not == nil
      stdin.expect(/rename (.*)\r\n/).should_not == nil
    end
  end

end
