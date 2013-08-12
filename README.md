SpreeTaxonPromotionRule
=======================

A rule to limit a promotion based on products from a specific taxon in the order.

Allows the ability to also set the number of products required from the specific taxon.

Installation
------------

Add spree_taxon_promotion_rule to your Gemfile:

```ruby
gem 'spree_taxon_promotion_rule', github: 'Hates/spree_taxon_promotion_rule'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_taxon_promotion_rule:install
```

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_taxon_promotion_rule/factories'
```
