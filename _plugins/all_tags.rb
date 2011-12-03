module Jekyll
  class RenderAllTags < Liquid::Tag

    def render(context)
      site = context.registers[:site]
      result = ''
      tags = Array.new()

      site.posts.each do |post|
        post.tags.each do |tag|
          if tags.include?(tag)==false
            tags.push(tag)
            result << "<li><a href='/tag/#{tag}'>#{tag.capitalize}</a></li>"
          end
        end
      end
      return result
    end
  end
end

Liquid::Template.register_tag('all_tags', Jekyll::RenderAllTags)
