# coding: utf-8
module Api::V1
  class PlacesController < ApiController
    doorkeeper_for :all

    def index
      @places = respond_with Place.list.paginate page: params[:page]
    end

    def show
      @place = respond_with Place.find(params[:id])
    end

    def create
      @place = current_resource_owner.places.create params[:place]
      respond_with @place
    end

    def search
      @page = params[:page] ? params[:page].to_i : 1
      if params[:q].blank? and (params[:lat].blank? or params[:lon].blank?)
        render json: {}
      else
        args = {q: params[:q],page: @page.to_s,lat: params[:lat],lon: params[:lon]}
        args.merge!({city: params[:city]}) if !params[:city].blank? and params[:city].scan(/自治/).blank?
        @places = Place.search(args).list.paginate(page: params[:page])
        render json: @places
      end
    end
  end
end
