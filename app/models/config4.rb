class Config4

  def self.config4(name)
    config = Rails.application.config_for(name)
    Class.new do
      config.each_pair do |key, value|
        define_singleton_method(key) { value }
        define_singleton_method("#{key}=") do |new_value|
          define_singleton_method(key) { new_value }
        end
      end
    end
  end

  class Facebook < config4(:facebook); end
end
