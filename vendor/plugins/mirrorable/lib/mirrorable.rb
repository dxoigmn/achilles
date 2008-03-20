# Mirrorable
module Mirrorable
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def mirror(field, &block)
      class_eval <<-END
        def real_#{field}
          read_attribute :#{field}
        end
        
        def #{field}
          real_#{field} ||
          mirror_#{field}
        end
        
        def #{field}=(value)
          value = nil if value.empty?
          write_attribute :#{field}, value
        end
      END
      
      class_eval do
        define_method "mirror_#{field}", &block
      end
    end
        
    def modifiable(field)
      class_eval <<-END
        def modified_#{field}
          if read_attribute(:modified_#{field})
            read_attribute(:#{field}).to_s
          else
            nil.to_s
          end
        end
        
        def update_#{field}
          unless read_attribute(:modified_#{field})
            write_attribute :#{field}, unmodified_#{field}
          end
        end
        
        def #{field}=(value)
          if value && !value.empty?
            write_attribute :modified_#{field}, true
            write_attribute :#{field}, value
          else
            write_attribute :modified_#{field}, false
            write_attribute :#{field}, unmodified_#{field}
          end
        end
      END
    end
  end
end

ActiveRecord::Base.class_eval do
  include Mirrorable
end
