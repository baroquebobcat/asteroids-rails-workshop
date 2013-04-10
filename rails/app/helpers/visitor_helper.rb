module VisitorHelper
  # Render the visitor navigation menu.
  def render_visitor_menu
    Navigation::Menu.new controller, self, class: "nav" do |visitor|
      visitor.add "Home", root_path, self
      visitor.add "About", about_path, self
    end.render
  end
end
