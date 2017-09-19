module ApplicationHelper
  def title(*parts)
    unless parts.empty?
      content_for :title do #name of content block is ":title" and block will be yield in application.html.erb title
        (parts.unshift("Wikiiki")).join(" - ")
      end
    end
  end
end
