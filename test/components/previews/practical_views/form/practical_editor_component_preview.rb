# frozen_string_literal: true

class PracticalViews::Form::PracticalEditorComponentPreview < ViewComponent::Preview
  def default
    render(PracticalViews::Form::PracticalEditorComponent.new(input_id: :test_id, aria_describedby_id: :described_id_id, direct_upload_url: "/url"))
  end
end
