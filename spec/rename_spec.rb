
require "pty"
require "expect"

RENAME = "../bin/rename"
TESTDIR = "testdir"

describe RENAME do
  before(:each) do
    @currdir = Dir.getwd
    Dir.mkdir(TESTDIR)
    Dir.chdir(TESTDIR)
  end

  after(:each) do
    Dir.chdir(@currdir)
    `rm -rf #{TESTDIR}`
  end

  it "should print its usage if it receives no arguments" do
    PTY.spawn("#{RENAME}") do |stdin, stdout, pid|
      stdin.expect(/(.*)Usage(.*)$/).should_not == nil
      stdin.expect(/rename (.*)\r\n/).should_not == nil
    end
  end

  it "should print its usage if --help is specified" do
    PTY.spawn("#{RENAME} --help") do |stdin, stdout, pid|
      stdin.expect(/(.*)Usage(.*)$/).should_not == nil
      stdin.expect(/rename (.*)\r\n/).should_not == nil
    end
  end

  it "should rename a file 'a' to 'b' when invoked as `rename 'a' 'b' a`" do
    `touch a`
    Dir.entries('.').should be_include('a')
    Dir.entries('.').should_not be_include('b')

    PTY.spawn("#{RENAME} 'a' 'b' a") do |stdin, stdout, pid|
      stdin.expect("").should == nil
    end
    Dir.entries('.').should_not be_include('a')
    Dir.entries('.').should be_include('b')
  end

  it "should rename a file 'bc' to 'cdc' when invoked as `rename 'b' 'cd' bc`" do
    `touch bc`
    Dir.entries('.').should be_include('bc')
    Dir.entries('.').should_not be_include('cdc')

    PTY.spawn("#{RENAME} 'b' 'cd' bc") do |stdin, stdout, pid|
      stdin.expect("").should == nil
    end
    Dir.entries('.').should_not be_include('bc')
    Dir.entries('.').should be_include('cdc')
  end

end
