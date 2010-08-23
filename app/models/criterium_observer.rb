class CriteriumObserver < ActiveRecord::Observer
  private
    def clear_criteria_cache
      Rails.cache.delete "all_criteria"
    end
  public
    def after_save(criterium)
      clear_criteria_cache
    end
    def after_destroy(criterium)
      clear_criteria_cache
    end
end
