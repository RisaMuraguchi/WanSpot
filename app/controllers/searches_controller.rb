class SearchesController < ApplicationController

  def search
		@model = params[:model]
		@content = params[:content]
		if @model == 'post'
			@records = Post.search_for(@content)
		else
			@records = User.search_for(@content)
		end
  end

end
