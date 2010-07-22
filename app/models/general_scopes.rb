module GeneralScopes
  def self.included(base)
    base.class_eval do
      named_scope(:options, lambda{|options|
        options ||= {}
        {}.merge!(options)
      })
      named_scope :except, lambda{|ids|
        if ids.kind_of?(Array)
          conditions = []
          ids.each do |id|
            conditions << sanitize_sql_for_conditions(["id != ?", id])
          end
          conditions = conditions.join(" AND ")
        elsif ids.kind_of?(Integer) || ids.kind_of?(String)
          conditions = ["id != ?", ids.to_i]
        end
        {:conditions => conditions}
      }
    end
  end
end