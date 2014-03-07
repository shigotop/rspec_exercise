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

  it "毎年一つ歳をとる" do
    @tree.oneYearPasses
    @tree.instance_variable_get(:@year).should == 1
  end

  it "七歳で死んでメッセージ表示" do
    6.times do
      @tree.oneYearPasses
    end
    output = capture(:stdout) do
      lambda{@tree.oneYearPasses}.should raise_error(SystemExit)
	end
    output.should be_include '木は死にました'
  end

  it "三年目から毎年年齢と同じ数の実をつける" do
    3.times do
      @tree.instance_variable_get(:@orangeCount).should == 0
      @tree.oneYearPasses
    end
	@orange = @tree.instance_variable_get(:@orangeCount) 
    @year = @tree.instance_variable_get(:@year)
	@orange.should == @year
  end

  it "木になっているオレンジの数を返す" do
    6.times do
      @tree.oneYearPasses
    end
	  orange = @tree.instance_variable_get(:@orangeCount)
	  @tree.countTheOranges.should == orange 
  end

  it "オレンジがあるときに摘むとオレンジの数が一つ減りオレンジの評価を表示" do
    6.times do
      @tree.oneYearPasses
    end
	count = @tree.instance_variable_get(:@orangeCount)
	['最高！','うまい', 'なかなか', '微妙', 'まずい'].should include capture(:stdout){@tree.pichAnOrange}.chomp
	@tree.instance_variable_get(:@orangeCount).should == count - 1
  end

  it "オレンジがないときに摘むとオレンジがないメッセージ表示" do
    capture(:stdout){@tree.pichAnOrange}.should be_include 'もうオレンジはありません'
  end

  it "ある年に取り残したオレンジは次の年に落ちる" do
  # 毎年、年齢個の実がなって年齢-1個の実が落ちるので、1個ずつ増える
    4.times do
      @tree.oneYearPasses
    end
    2.times do
      @tree.oneYearPasses
      count = @tree.instance_variable_get(:@orangeCount)
	  year = @tree.instance_variable_get(:@year)
	  count.should == year - 3
    end
  end
end
