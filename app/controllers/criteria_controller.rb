class CriteriaController < ApplicationController

  before_filter :require_user
  before_filter :normalize_params
  
  private
    def normalize_params
      Criterium.type_options.each do |type|
        if params[type[1].underscore.to_sym]
          params[:criterium] = params[type[1].underscore.to_sym]
        end
      end
    end
  protected
  public  
    def index
      @criteria = Criterium.all :order => 'number'
    end

    def show
      @criterium = Criterium.find(params[:id])
    end

    def new
      @criterium = Criterium.new
    end

    def edit
      @criterium = Criterium.find(params[:id])
    end

    def create
      @criterium = Criterium.new(params[:criterium])

      if @criterium.save
        notice = "#{@criterium.kind.to_s.titleize} saved."
        if @criterium.kind == 'GrantActivity'
          redirect_to(edit_criterium_url(@criterium), :notice => "#{notice}" + 
          " You can assign this Grant Activity to Objectives to help trim" +
          " selectable options when recording Activities.")
        else
          redirect_to(criteria_url, :notice => notice)
        end
      else
        render :action => "new"
      end
    end

    def update
      @criterium = Criterium.find(params[:id])

      if @criterium.update_attributes(params[:criterium])
        redirect_to(criteria_url, :notice => "#{@criterium.kind.to_s.titleize} updated.")
      else
        render :action => "edit"
      end
    end

    def destroy
      @criterium = Criterium.find(params[:id])
      @criterium.destroy

      redirect_to(criteria_url)
    end
end
