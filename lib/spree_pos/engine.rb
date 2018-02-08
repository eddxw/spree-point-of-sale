module SpreePos

  class Engine < Rails::Engine
    engine_name 'spree_pos'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "spree.spree_pos.preferences", :after => "spree.environment" do |app|
      SpreePos::Config = SpreePos::Configuration.new
      # ::CARD_TYPE = ['Visa', 'MasterCard', 'Verve', 'AmericanExpress', 'China UnionPay']
      app.config.spree.payment_methods << Spree::PaymentMethod::PointOfSale
    end

    def self.activate

      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      Dir.glob(File.join(File.dirname(__FILE__), '../../../app/overrides/*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      Spree::Product.class_eval do
        delegate :ean, to: :master
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
