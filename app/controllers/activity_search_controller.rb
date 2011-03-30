module ActivitySearchController
private
  def load_activities
    @search = ActivitySearch.new(params[:activity_search] || {})
    @activities = @search.activities
  end
  
  def search_params
    @search_params ||= if params[:activity_search].present?
        {:activity_search => params[:activity_search]}
      else
        {}
      end
  end
end