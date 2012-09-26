describe Price do
  it "must have price" do
    price = Price.create
    price.id.should eq(nil)
  end


  let(:price) {Price.create :price => 1}

  describe "bills <<" do
    it "bill" do
      price.bills << Bill.create(:total => 5)
    end
  end
end
