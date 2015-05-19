class ArticlesController < BaseController

  def index
    @articles = Article.published
  end

  def show
    @article = Article.published.find(params[:id])
    add_tasty_breadcrumb @article.get_content(current_lang).title, article_path(@article)
  end

  def preview
    @article = Article.find(params[:id])
    add_tasty_breadcrumb @article.get_content(current_lang).title, preview_article_path(@article)

    respond_to do |format|
      format.html { render :show }
    end
  end
end
