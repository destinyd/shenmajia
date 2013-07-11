class BillsController < InheritedResources::Base
  layout 'no_sidebar',only: [:new,:create]
  before_filter :authenticate_user!,only: [:new,:create]
  actions :all, except: [:edit,:update,:destroy]
  belongs_to :place, optional: true
  # belongs_to :shop, optional: true
  respond_to :html

  respond_to :js, only: [:index, :new]

  #caches_page :index,:show
  #cache_sweeper :bill_sweeper
  def show
    show! do
      add_crumb(I18n.t("controller.bills"), bills_path)
      add_crumb(@bill, bill_path(@bill))
    end
  end

  def create
    @bill = current_user.bills.new params[:bill]
    return redirect_to(new_bill_path,error:t('error.fault')) if params[:place_id].blank? or session[:b].blank? or session[:b][params[:place_id]].blank?
      @bill.locatable = @place = Place.find(params[:place_id])
      session[:b][@place.id.to_s].each do |key,item|
        bp = @bill.bill_prices.new
        bp.amount = item[:amount]
        unless params[:image].blank?
          bp.image = params[:image][key]
          @bill.picture_count +=1 unless params[:image][key].blank?
        end
        if item[:price_id]
          bp.price_id = item[:price_id]
        else
          bp.price = Price.where(
           locatable_type: 'Place',
           locatable_id: params[:place_id],
           good_id: key,
           price: item[:price],
           lat: @bill.locatable.lat,
           lon: @bill.locatable.lon,
           city_id: @bill.locatable.city_id
           ).first_or_create({type_id: 0,user_id: @bill.user_id}, on: :bill)
        end
      end
      create!{|success,failure| 
        success.html{
          session[:b][@place.id.to_s] = nil
        }
        failure.html{
          render :new
        }
      }
    #end
  end

  protected
  def collection
    if parent?
      add_crumb(I18n.t("controller.#{parent.class.name.downcase.pluralize}"), polymorphic_path(parent.class))
      add_crumb(parent.name, polymorphic_path(parent))
    end
    add_crumb(I18n.t("controller.bills"), bills_path)

    @bills ||= end_of_association_chain.recent.page(params[:page])
  end
end
