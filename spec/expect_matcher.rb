
require 'expect'

# Custom matcher that checks for expected IO stream output.
module ExpectMatcher

  class Expect
    def initialize(expected)
      @expected = expected
    end

    def matches? (target)
      @target = target
      @target.expect(@expected) != nil
    end

    def failure_message
      "expected <#{@target.to_s}> to contain the the text/pattern " +
      "<#{@expected.to_s}>"
    end

    def negative_failure_message
      "expected <#{@target.to_s}> to not contain the the text/pattern " +
      "<#{@expected.to_s}>"
    end
  end

  def expect(expected)
    Expect.new(expected)
  end

end
