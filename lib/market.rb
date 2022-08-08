class Market

  attr_reader :name, :vendors, :date

  def initialize(name)
    @name = name
    @vendors = []
    @date = Time.now.strftime("%d/%m/%Y")
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

  def sell(item, qty)
    able_to_sell = unique_items.include?(item) && total_inventory[item][:quantity] >= qty
    reduce_stocks(item, qty) if able_to_sell
    able_to_sell
  end

  def reduce_stocks(item, qty)
    vendors_that_sell(item).each do |vendor|
      if vendor.inventory[item] >= qty
        vendor.inventory[item] -= qty
        qty = 0
      else
        qty -= vendor.inventory[item]
        vendor.inventory[item] = 0
      end
    end
  end

end
