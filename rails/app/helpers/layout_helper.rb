module LayoutHelper
  # Defines the page title.  More specifically, the HTML title tag as found
  # within the page header.  Accepts the following arguments:
  # * *title* - The title of the page, defaults to a titleized version of the action name.
  # * *separator* - The sub-page separator (i.e. My Site - Sub-page), defaults to:  '-'.
  def title title = action_name.titleize, separator = '|'
    content_for(:title) {[title, SYSTEM_LABEL].compact * " #{separator} "}
  end

  # Dynamically loads stylesheet files.
  def stylesheet *args
    content_for(:stylesheet) {stylesheet_link_tag(*args)}
  end

  # Dynamically loads javascript files.
  def javascript *args
    content_for(:javascript) {javascript_include_tag(*args)}
  end
end
