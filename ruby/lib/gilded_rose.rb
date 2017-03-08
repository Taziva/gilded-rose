class GildedRose
    MIN_QUALITY = 0
    MAX_QUALITY = 50
    CHANGE = 1

    def initialize(items)
        @items = items
    end

    def update_quality
        @items.each do |item|
            next unless valid_quality?(item.quality)
            update_normal_item(item) unless special_items?(item.name)
            update_special_item(item) if special_items?(item.name)
        end
    end

    def special_items?(name)
        aged_brie?(name) || backstage_pass?(name) || legendary_item?(name) ? true : false
    end

    def update_special_item(item)
        check_sell_in(item)
        update_backstage_pass(item) if backstage_pass?(item.name)
    end

    def check_sell_in(item)
        decrease_sell_in(item)
        add_quality(item) if item.sell_in < 0 && aged_brie?(item.name)
        add_quality(item) if item.sell_in
    end

    def aged_brie?(name)
        name == 'Aged Brie'
    end

    def conjured?(item)
        item.name.include?"Conjured"
    end

    def backstage_pass?(name)
        name == 'Backstage passes to a TAFKAL80ETC concert'
    end

    def valid_quality?(quality)
        quality >= MIN_QUALITY && quality < MAX_QUALITY
    end

    def legendary_item?(name)
        name == 'Sulfuras, Hand of Ragnaros'
    end

    def deduct_quality(item)
        item.quality -= CHANGE
        item.quality -= CHANGE if conjured?(item)
        item.quality = MIN_QUALITY if item.quality < MIN_QUALITY
    end

    def add_quality(item)
        item.quality += CHANGE
        item.quality += CHANGE if conjured?(item)
        item.quality = MAX_QUALITY if item.quality > MAX_QUALITY
    end

    def decrease_sell_in(item)
        item.sell_in -= 1
    end

    def update_backstage_pass(item)
        add_quality(item) if item.sell_in < 11
        add_quality(item) if item.sell_in < 6
        worthless(item) if item.sell_in < 0
    end

    def update_normal_item(item)
        deduct_quality(item)
        decrease_sell_in(item)
        deduct_quality(item) if item.sell_in < 0
    end

    def worthless(item)
        item.quality -= item.quality
    end
end

class Item
    attr_accessor :name, :sell_in, :quality

    def initialize(name, sell_in, quality)
        @name = name
        @sell_in = sell_in
        @quality = quality
    end

    def to_s
        "#{@name}, #{@sell_in}, #{@quality}"
    end
end
