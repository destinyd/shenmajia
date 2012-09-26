describe Shop do
  [:name].each do |attr|
    it "requires #{attr}" do
      e = Shop.create
      e.should have_at_least(1).error_on(attr)
    end
  end

  let(:shop){Shop.create! :name => 'shop1'}
  describe "#bills<<" do
    it "bills" do
      shop.bills << Bill.create(total:1)
      shop.bills << Bill.create(total:2)
      shop.should have(2).bills
    end
  end

end


