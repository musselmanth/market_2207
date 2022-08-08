class Market

  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map(&:name)
  end

  def vendors_that_sell(item)
    @vendors.find_all{ |vendor| vendor.inventory.keys.include?(item) }
  end

  def unique_items
    @vendors.flat_map{ |vendor| vendor.inventory.keys }.uniq
  end

  def total_inventory
    unique_items.inject({}) do |inventory, item|
      inventory[item] = {
        quantity: @vendors.sum{ |vendor| vendor.check_stock(item)},
        vendors: vendors_that_sell(item)
      }
      inventory
    end
  end

  def sorted_item_list
    unique_items.map(&:name).sort
  end

  def overstocked?(item)
    total_inventory[item][:vendors].length > 1 && total_inventory[item][:quantity] > 50
  end

  def overstocked_items
    unique_items.find_all{ |item| overstocked?(item) }
  end

end
