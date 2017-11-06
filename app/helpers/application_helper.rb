# Call by forms to set browser tab title
module ApplicationHelper
  def title(*parts)
    unless parts.empty?
      content_for :title do #name of content block is ":title" and block will be yield in application.html.erb title
        (parts.unshift("Wikiiki")).join(" - ")
      end
    end
  end

  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end
end
