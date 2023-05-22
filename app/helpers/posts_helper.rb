module PostsHelper

  def render_with_hashtags(caption)
    caption.gsub(/#\p{Word}+/){|word| link_to word, "/post/hashtag/#{word.delete("#")}"}.html_safe
  end

end
