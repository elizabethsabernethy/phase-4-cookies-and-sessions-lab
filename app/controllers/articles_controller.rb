class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:page_views] ||= 0
    session[:page_views] +=1
    article = Article.find(params[:id])
    if session[:page_views] <= 3
    render json: article, session: session
    else
      render_error
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  def render_error
    render json: {error: "Maximum pageview limit reached"}, status: :unauthorized
  end

end
