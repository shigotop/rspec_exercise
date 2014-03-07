require "./spec_helper.rb"
require "../lib/orange_tree.rb"
require "stringio"

def capture(stream)
  begin
    stream = stream.to_s
	eval "$#{stream} = StringIO.new"
	yield
	result = eval("$#{stream}").string
  ensure
	eval "$#{stream} = #{stream.upcase}"
  end
  result
end

describe OrangeTree do
  before :each do
    @tree = OrangeTree.new
  end

  it "一年経過" do
    @tree.oneYearPasses
  	@tree.instance_variable_get(:@year).should == 1
  end

  it "七年で死んでメッセージ表示" do
    6.times do
	  @tree.oneYearPasses
	end
	capture(:stdout){@tree.oneYearPasses}.should == '木は死にました'  :
  end

  it "七年で死んでexit" do
	6.times do
	  @tree.oneYearPasses
	end
	lambda {@tree.oneYearPasses}.should raise_error(SystemExit)
  end
end