# Mirrorable
module Mirrorable
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_mirrorable(field, &block)
      class_eval <<-END
        def #{field.to_s}
          read_attribute(:#{field}) ||
          #{field}_mirror
        end

        def real_#{field.to_s}
          read_attribute(:#{field})
        end

        def #{field.to_s}=(value)
          value = nil if value.respond_to?(:empty?) && value.empty?
          write_attribute('#{field}', value)
        end
      END

      class_eval do
        define_method "#{field}_mirror", &block
      end
    end

    def acts_as_modifiable(field, &block)
      class_eval <<-END
        def real_#{field.to_s}
          return nil unless #{field.to_s}_modified?
          read_attribute(:#{field})
        end

        def update_#{field.to_s}!
          update_#{field.to_s}
          save!
        end

        def update_#{field.to_s}
          write_attribute(:#{field}, #{field}_default) unless read_attribute(:#{field}_modified)
        end

        def #{field.to_s}=(value)
          if value.nil? ||
             (value.respond_to?(:empty?) && value.empty?)
            write_attribute(:#{field}_modified, false)
            update_#{field.to_s}
          else
            write_attribute(:#{field}_modified, true)
            write_attribute(:#{field}, value)
          end
        end
      END

      class_eval do
        define_method "#{field.to_s}_default", &block
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include Mirrorable
end
