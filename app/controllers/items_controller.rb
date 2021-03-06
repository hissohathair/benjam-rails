class ItemsController < ApplicationController

respond_to :html, :json
before_filter :set_client ,except: [:audio, :image]

# GET /items
# GET /items.json
# GET /items/1/items
# GET /items/1/items.json
  def index

    @mode = params[:mode] || cookies[:mode] || 'default'
    @client = Client.where('name = ?', params[:client_id]).first
    @item = params[:item_id] == nil ? Item.root : Item.find(params[:item_id])
    @items = Item.order(:position).where('parent_id = ? AND client_id = ?', @item.id, @client.id)

    respond_to do |format|
        format.html {
            respond_with @items
        }
        format.json {
            extract = []
            @items.each do |i|
                extract << item_extract(i)
            end
            render :json => extract
            
        }
    end
  end

  def chooser

  end

# GET /items/1/images.jpg
 def image
     @item = Item.find(params[:id])
     respond_to do |format|
         format.jpg do
             self.response.headers["Content-Type"] ||= 'image/jpg'
             send_data @item.image, options = { :type => 'image/jpg', :disposition => 'inline'}
            end
     end
 end
 # GET /items/1/audio.wav
def audio
    @item = Item.find(params[:id])
    respond_to do |format|
        format.wav do
            self.response.headers["Content-Type"] ||= 'audio/wav'
            send_data @item.audio,  options: {type:'audio/wav; header=present', disposition:'inline'}
        end
    end
end

# GET /items/1
# GET /items/1.json
 def show
    @mode =  params[:mode] || cookies[:mode] || 'default'

    @item = Item.find(params[:id])
    @items = @item.children.order(:position)
    respond_to do |format|
        format.html {
            if(@items.empty?)
                render :show_choice
            else
                render :show
            end
        }
        format.json {
            render :json => item_extract(@item)
        }
    end
  end  


  def new
    @item = Item.new new_item_params
    if params[:item_id]
      @item.parent_id = params[:item_id]
      @item.position = Item.where(parent_id: params[:item_id]).count + 1
    end
  end

  def create
    @item = Item.new item_params
    @item.image = params[:item][:image].read if params[:item][:image]
    @item.audio = params[:item][:audio].read if params[:item][:audio]
    @item.client = @client
    puts @item.inspect
    @item.save
    if params[:item][:parent_id].present?
      path = client_item_path(@client.name, @item.parent)
    else
      path = client_path(@client.name)
    end
    respond_to do |format|
      format.html { redirect_to path, notice: 'Created'}
      format.json { render json: @item }
    end

  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    if @item.parent
      path = client_item_path(@client.name, @item.parent)
    else
      path = client_path(@client.name)
    end

    respond_to do |format|
      format.html { redirect_to path, notice: 'Item deleted' }
      format.json { head :no_content , status: :ok}
    end
  end

  def set_client
    @client = Client.where('name = ?', params[:client_id]).first if params[:client_id]
    @client = Client.where('name = ?', params[:item][:client_id]).first if params[:item] && params[:item][:client_id]
  end

  private

  def new_item_params
    params.permit(:name, :parent_id, :position, :image, :audio,:client_id)
  end

  def item_params
    params.require(:item).permit(:name, :parent_id, :position)
  end
  
  def item_extract(item)
      return { :id => item.id, :name => item.name, :position => item.position, :parent_id => item.parent_id,
          :image => item_path(item.id) + "/image.jpg", :audio => item_path(item.id) + "/audio.wav" }
      end
end
