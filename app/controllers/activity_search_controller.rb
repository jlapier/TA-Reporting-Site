module ActivitySearchController
private
  def load_activities
    @search = ActivitySearch.new(params[:activity_search] || {})
    @activities = @search.activities
  end
end