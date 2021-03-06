class AttrsController < ApplicationController
  before_filter :find_able
  before_filter :authenticate_user!,except: [:index,:show]
  def index
    @attrs = Hash.new
    @able.attrs.supported.each{|attr| @attrs[attr.name] = attr.value}

    render json: @attrs
  end

  def new
    @attr = @able.attrs.build
  end

  def show
    @attrs = @able.attrs.where(name: params[:id])
  end

  def create
    @attr= @able.attrs.build(params[:attr])
    @attr.save
  end

  #def review
  #end
end
