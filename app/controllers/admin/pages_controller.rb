class Admin::PagesController < AdminController

  before_filter :load_page, only: [:show, :edit, :update, :delete]

  def index
    @pages = Cms::Page.all
  end

  def show
  end

  def new
    @page = Cms::Page.new
  end

  def create
    @page = Cms::Page.new(page_params)
    if @page.save
      redirect_to admin_pages_url, notice: 'Contenu créé avec succès.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @page.update_attributes(page_params)
      redirect_to admin_pages_url, notice: 'Les modifications ont bien été enregisrées.'
    else
      render :edit
    end
  end

  def delete
    @page.destroy
    redirect_to admin_pages_url, notice: 'Le contenu a bien été supprimé.'
  end

  private

    def load_page
      @page = Cms::Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:name, :title, :slug, :meta_desc, :body)
    end

end