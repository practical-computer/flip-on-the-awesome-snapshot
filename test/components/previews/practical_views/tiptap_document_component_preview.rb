# frozen_string_literal: true

class PracticalViews::TiptapDocumentComponentPreview < ViewComponent::Preview
  def default
    render(PracticalViews::TiptapDocumentComponent.new)
  end
end
