require 'gilded_rose'
describe GildedRose do

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    context "when item passes sell by date"do
      it "quality degrades twice as fast" do
        items = [Item.new('something',0,10)]
        gilded_rose = GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 8
      end
    end

    context "when item is before sell by date"do
      it "quality degrades by 1" do
        items = [Item.new('something',1,10)]
        gilded_rose = GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 9
      end
      it "reduces sell in date by 1" do
        items = [Item.new('something',3,10)]
        gilded_rose = GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 2
      end
    end

    it "The Quality of an item is never more than 50" do
      items = [Item.new('Aged Brie',10,50)]
      gilded_rose = GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 50
      expect(items[0].quality).not_to eq 51
    end

    it "quality is never a negative" do
      items = [Item.new('something',0,0)]
      gilded_rose = GildedRose.new(items).update_quality()
      expect(items[0].quality).not_to eq -1
      expect(items[0].quality).to eq 0
    end
    context "Aged Brie" do
      it "actually increases in Quality the older it gets" do
        items = [Item.new('Aged Brie',10,10)]
        gilded_rose = GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 11
      end
    end

    context "Sulfuras, Hand of Ragnaros" do
      it "never has to be sold" do
        items = [Item.new('Sulfuras, Hand of Ragnaros',10,80)]
        gilded_rose = GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 80
      end
      it "never decreases in Quality" do
        items = [Item.new('Sulfuras, Hand of Ragnaros',0,80)]
        gilded_rose = GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 0
      end
    end

    context "Backstage passes to a TAFKAL80ETC concert" do
      it "increases in Quality as it’s SellIn value approaches" do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert',20,20)]
        gilded_rose = GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 21
      end
      it "Quality increases by 2 when sell_in <= 10 days " do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert',10,20)]
        gilded_rose = GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 22
      end
      it "Quality increases by 3 when sell_in <= 5 days " do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert',5,20)]
        gilded_rose = GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 23
      end
      it "Quality drops to 0 after the concert" do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert',0,20)]
        gilded_rose = GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0
      end
      it "Quality is never more than 50" do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert',10,50)]
        gilded_rose = GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 50
      end
    end
  end
end
