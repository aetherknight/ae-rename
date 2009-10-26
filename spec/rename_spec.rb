
require "rubygems"
require "mkdtemp"

require "pty"
require "expect"

RENAME = File.join("bin","rename")

describe RENAME do
  before(:each) do
    @currdir = Dir.getwd
    @rename = File.join(@currdir, RENAME)
    @tempdir = Dir.mkdtemp
    Dir.chdir(@tempdir)
  end

  after(:each) do
    Dir.chdir(@currdir)
    `rm -rf #{@tempdir}`
  end

  it "should print its usage if it receives no arguments" do
    PTY.spawn("#{@rename}") do |stdin, stdout, pid|
      stdin.expect(/(.*)Usage(.*)$/).should_not == nil
      stdin.expect(/rename (.*)\r\n/).should_not == nil
    end
  end

  it "should print its usage if --help is specified" do
    PTY.spawn("#{@rename} --help") do |stdin, stdout, pid|
      stdin.expect(/(.*)Usage(.*)$/).should_not == nil
      stdin.expect(/rename (.*)\r\n/).should_not == nil
    end
  end

  it "should rename a file 'a' to 'b' when invoked as `rename 'a' 'b' a`" do
    `touch a`
    Dir.entries('.').should be_include('a')
    Dir.entries('.').should_not be_include('b')

    PTY.spawn("#{@rename} 'a' 'b' a") do |stdin, stdout, pid|
      stdin.expect("").should == nil
    end
    Dir.entries('.').should_not be_include('a')
    Dir.entries('.').should be_include('b')
  end

  it "should rename a file 'bc' to 'cdc' when invoked as `rename 'b' 'cd' bc`" do
    `touch bc`
    Dir.entries('.').should be_include('bc')
    Dir.entries('.').should_not be_include('cdc')

    PTY.spawn("#{@rename} 'b' 'cd' bc") do |stdin, stdout, pid|
      stdin.expect("").should == nil
    end
    Dir.entries('.').should_not be_include('bc')
    Dir.entries('.').should be_include('cdc')
  end

  it "should rename a file 'bc' to 'ccd' when invoked as `rename 'b(.)' '\\1cd' bc`" do
    `touch bc`
    Dir.entries('.').should be_include('bc')
    Dir.entries('.').should_not be_include('ccd')

    PTY.spawn("#{@rename} 'b(.)' '\\1cd' bc") do |stdin, stdout, pid|
      stdin.expect("").should == nil
    end
    Dir.entries('.').should_not be_include('bc')
    Dir.entries('.').should be_include('ccd')
  end

  it "should be able to rename more than one file" do
    `touch a b c`
    Dir.entries('.').should be_include('a')
    Dir.entries('.').should be_include('b')
    Dir.entries('.').should be_include('c')
    Dir.entries('.').should_not be_include('aa')
    Dir.entries('.').should_not be_include('ba')
    Dir.entries('.').should_not be_include('ca')

    PTY.spawn("#{@rename} '.' '\\0a' *") do |stdin, stdout, pid|
      stdin.expect("").should == nil
    end

    Dir.entries('.').should_not be_include('a')
    Dir.entries('.').should_not be_include('b')
    Dir.entries('.').should_not be_include('c')
    Dir.entries('.').should be_include('aa')
    Dir.entries('.').should be_include('ba')
    Dir.entries('.').should be_include('ca')
  end

  it "should print each file renaming if --verbose is specified" do
    `touch a b c`
    Dir.entries('.').should be_include('a')
    Dir.entries('.').should be_include('b')
    Dir.entries('.').should be_include('c')
    Dir.entries('.').should_not be_include('aa')
    Dir.entries('.').should_not be_include('ba')
    Dir.entries('.').should_not be_include('ca')

    PTY.spawn("#{@rename} --verbose '.' '\\0a' *") do |stdin, stdout, pid|
      stdin.expect("a => aa").should_not == nil
      stdin.expect("b => ba").should_not == nil
      stdin.expect("c => ca").should_not == nil
    end

    Dir.entries('.').should_not be_include('a')
    Dir.entries('.').should_not be_include('b')
    Dir.entries('.').should_not be_include('c')
    Dir.entries('.').should be_include('aa')
    Dir.entries('.').should be_include('ba')
    Dir.entries('.').should be_include('ca')
  end

  it "should print each file renaming but not actually rename the files if --pretend is specified" do
    `touch a b c`
    Dir.entries('.').should be_include('a')
    Dir.entries('.').should be_include('b')
    Dir.entries('.').should be_include('c')
    Dir.entries('.').should_not be_include('aa')
    Dir.entries('.').should_not be_include('ba')
    Dir.entries('.').should_not be_include('ca')

    PTY.spawn("#{@rename} --pretend '.' '\\0a' *") do |stdin, stdout, pid|
      stdin.expect("a => aa").should_not == nil
      stdin.expect("b => ba").should_not == nil
      stdin.expect("c => ca").should_not == nil
    end

    Dir.entries('.').should be_include('a')
    Dir.entries('.').should be_include('b')
    Dir.entries('.').should be_include('c')
    Dir.entries('.').should_not be_include('aa')
    Dir.entries('.').should_not be_include('ba')
    Dir.entries('.').should_not be_include('ca')
  end

end
