require 'spec_helper'

describe Spree::Promotion::Rules::Taxon do

  let(:rule) { Spree::Promotion::Rules::Taxon.new }

  context "#eligible?(order)" do
    let(:order) { Spree::Order.new }

    it "should be eligible if there are no taxons" do
      rule.stub(eligible_taxons: [])

      expect(rule).to be_eligible(order)
    end

    before do
      @taxon1 = mock_model Spree::Taxon
      @product1 = mock_model Spree::Product, taxons: [@taxon1]
      @line_item1 = mock_model Spree::LineItem, product: @product1, quantity: 1

      @taxon2 = mock_model Spree::Taxon
      @product2 = mock_model Spree::Product, taxons: [@taxon2]
      @line_item2 = mock_model Spree::LineItem, product: @product2, quantity: 1

      @taxon3 = mock_model Spree::Taxon
      @product3 = mock_model Spree::Product, taxons: [@taxon3]
      @line_item3 = mock_model Spree::LineItem, product: @product3, quantity: 1

      @taxon4 = mock_model Spree::Taxon
      @taxon4a = mock_model Spree::Taxon, self_and_descendants: [@taxon4]
      @product4 = mock_model Spree::Product, taxons: [@taxon4]
      @product5 = mock_model Spree::Product, taxons: [@taxon4]

      @line_item4 = mock_model Spree::LineItem, product: @product4, quantity: 1
      @line_item5 = mock_model Spree::LineItem, product: @product5, quantity: 1
      @line_item6 = mock_model Spree::LineItem, product: @product5, quantity: 2
    end

    context "for one product" do

      before { rule.preferred_number_of_products = 1 }

      it "is eligible if one of the products is in an eligible taxon" do
        order.stub(line_items: [@line_item1, @line_item2])
        rule.stub(eligible_taxons: [@taxon2, @taxon3])

        expect(rule).to be_eligible(order)
      end

      it "is eligible if one of the products is in an eligible taxon's child taxon" do
        order.stub(line_items: [@line_item4])
        rule.stub(taxons: [@taxon4a])

        expect(rule).to be_eligible(order)
      end

      it "is not eligible if none of the products is in an eligible taxon" do
        order.stub(line_items: [@line_item1])
        rule.stub(eligible_taxons: [@taxon2, @taxon3])

        expect(rule).not_to be_eligible(order)
      end

    end

    context "for multiple number of products" do

      before { rule.preferred_number_of_products = 2 }

      it "is eligible if all of the products is in an eligible taxon" do
        order.stub(line_items: [@line_item1, @line_item2])
        rule.stub(eligible_taxons: [@taxon1, @taxon2])

        expect(rule).to be_eligible(order)
      end

      it "is eligible if all of the products is in an eligible taxon's child taxon" do
        order.stub(line_items: [@line_item4, @line_item5])
        rule.stub(taxons: [@taxon4a])

        expect(rule).to be_eligible(order)
      end

      it "is eligible if all of the products is in an eligible taxon's child taxon" do
        order.stub(line_items: [@line_item6])
        rule.stub(taxons: [@taxon4a])

        expect(rule).to be_eligible(order)

      end

      it "is not eligible if one of the products is in an eligible taxon" do
        order.stub(line_items: [@line_item1, @line_item2])
        rule.stub(eligible_taxons: [@taxon2, @taxon3])

        expect(rule).not_to be_eligible(order)
      end

    end

  end

end
