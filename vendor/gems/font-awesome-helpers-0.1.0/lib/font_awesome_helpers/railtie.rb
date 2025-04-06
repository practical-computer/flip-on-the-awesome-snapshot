module FontAwesomeHelpers
  class Railtie < ::Rails::Railtie
    initializer 'font-awesome-helpers.view_helpers' do
      ActiveSupport.on_load(:action_view) do
        include FontAwesomeHelpers::ViewHelpers
      end
    end
  end
end
