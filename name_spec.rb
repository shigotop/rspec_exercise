require "./spec_helper.rb"
require "./nameinspecter.rb"

describe NameInspecter do
  before do
    obj = NameInspecter.new
  end

  it "shigotoはfalse" do
    @obj.is_shigotop('shigoto').should be_false:
  end

  it "shigotopはtrue" do
    @obj.is_shigotop('shigotop').should be_true
  end

  it "shigotopoはfalse" do
    @obj.is_shigotop("shigotopo").should be_false
  end
end
