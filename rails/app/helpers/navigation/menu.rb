class Navigation::Menu < Navigation::Item
  def initialize controller, template, options = {}, &block
    @@controller = controller
    @options = {class: :menu}.merge options
    @level = 0
    @children = []
    @template = template
    yield self if block_given?
  end

  def render
    content_tag(:ul, @children.map(&:render).join.html_safe, @options)
  end    
end
