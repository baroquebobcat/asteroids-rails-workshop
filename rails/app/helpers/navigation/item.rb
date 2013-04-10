class Navigation::Item
  attr_accessor :children, :link

  def initialize title, link, level, template, item_options = {}, link_options = {}
    @title, @link, @level, @template, @item_options, @link_options = title, link, level, template, item_options, link_options
    @children = []
  end

  def add title, link, template, item_options = {}, link_options = {}, &block
    Navigation::Item.new(title, link, @level +1, template, item_options, link_options).tap do |adding|
      @children << adding
      yield adding if block_given?
    end
  end

  def render
    @item_options[:class] = @item_options[:class].to_s + " active" if active? && !@item_options[:deactivate]
    content_tag(:li, link_to(@title, @link, @link_opts) + child_output, @item_options).to_s
  end

  def level_class
    "menu_level_#{@level}"
  end

  def child_output
    children.empty? ? '' : content_tag(:ul, @children.collect(&:render).join.html_safe, class: level_class)
  end

  def active?
    children.any?(&:active?) || on_current_page?
  end

  def on_current_page?
    current_page?(@link)
  end

  cattr_accessor :controller
  def controller # make it available to current_page? in UrlHelper
    @@controller
  end

  # Punts to the helper context for helper methods not defined in this class.
  def method_missing *args, &block
    @template.public_send *args, &block
  end  
end
