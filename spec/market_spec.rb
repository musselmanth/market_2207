require './lib/vendor'
require './lib/market'

RSpec.describe Market do
  let(:market) { Market.new("South Pearl Street Farmers Market") }
  let(:item1) { Item.new({name: 'Peach', price: "$0.75"}) }
  let(:item2) { Item.new({name: 'Tomato', price: '$0.50'}) }
  let(:item3) { Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"}) }
  let(:item4) { Item.new({name: "Banana Nice Cream", price: "$4.25"}) }
  let(:vendor1) { Vendor.new("Rocky Mountain Fresh") }
  let(:vendor2) { Vendor.new("Ba-Nom-a-Nom") }
  let(:vendor3) { Vendor.new("Palisade Peach Shack") }

  before(:each) do
    vendor1.stock(item1, 35)
    vendor1.stock(item2, 7)
    vendor2.stock(item3, 25)
    vendor2.stock(item4, 50)
    vendor3.stock(item1, 65)
    vendor3.stock(item3, 10)
  end

  it 'exists and has attributes' do
    expect(market).to be_instance_of(Market)
    expect(market.name).to eq("South Pearl Street Farmers Market")
    expect(market.vendors).to eq([])
  end

  it 'can add vendors' do
    market.add_vendor(vendor1)
    market.add_vendor(vendor2)
    market.add_vendor(vendor3)
    expect(market.vendors).to eq([vendor1, vendor2, vendor3])
  end

  context 'vendor integration' do
    before(:each) do
      market.add_vendor(vendor1)
      market.add_vendor(vendor2)
      market.add_vendor(vendor3)
    end

    it 'can return a list of vendor names' do
      expect(market.vendor_names).to eq(["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
    end

    it 'can return a list of vendors that sell a particular item' do
      expect(market.vendors_that_sell(item1)).to eq([vendor1, vendor3])
      expect(market.vendors_that_sell(item4)).to eq([vendor2])
    end

    it 'can return an array of unique items sold' do
      expect(market.unique_items).to eq([item1, item2, item3, item4])
    end

    xit 'can return totaly inventory hash' do
      expected = {
        item1 => {
          quantity: 100,
          vendors: [vendor1, vendor3]
        },
        item2 => {
          quantity: 7,
          vendors: [vendor1]
        },
        item3 => {
          quantity: 50,
          vendors: [vendor2, vendor3]
        },
        item4 => {
          quantity: 35,
          vendors: [vendor2]
        }
      }
       
      expect(market.total_inventory).to eq(expected)
    end

  end

end