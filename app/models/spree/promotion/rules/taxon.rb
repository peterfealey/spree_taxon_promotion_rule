# A rule to limit a promotion based on products from certain taxons in the order.
# Can require all or any of the taxons to be present.
module Spree
  class Promotion
    module Rules
      class Taxon < PromotionRule
        has_and_belongs_to_many :taxons, class_name: '::Spree::Taxon', join_table: 'spree_taxons_promotion_rules', foreign_key: 'promotion_rule_id'

        preference :number_of_products, :integer, default: 1

        # Scope/association that is used to test eligibility
        def eligible_taxons
          taxons.collect { |t| t.self_and_descendants }.flatten.uniq
        end

        def eligible?(order, options = {})
          return true if eligible_taxons.empty?

          matching_line_items = []
          order.line_items.each do |line_item|
            if (line_item.product.taxons & eligible_taxons).present?
              matching_line_items << line_item
            end
          end

          matching_line_items.sum(&:quantity) >= preferred_number_of_products
        end

        def taxon_ids_string
          taxon_ids.join(',')
        end

        def taxon_ids_string=(s)
          self.taxon_ids = s.to_s.split(',').map(&:strip)
        end

      end
    end
  end
end
