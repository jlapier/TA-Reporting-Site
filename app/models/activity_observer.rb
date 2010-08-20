class ActivityObserver < ActiveRecord::Observer
  private
    def clear_summary_maps
      FileUtils.rm_rf(File.join(Rails.root, "public", "summary_reports"))
    end
  public
    def after_save(activity)
      clear_summary_maps
    end
    def after_destroy(activity)
      clear_summary_maps
    end
end