# frozen_string_literal: true

class PracticalViews::RelativeTimeComponentPreview < ViewComponent::Preview
  def default
    render(PracticalViews::RelativeTimeComponent.new(time: 5.minutes.ago))
  end

  def future
    render(PracticalViews::RelativeTimeComponent.new(time: 5.minutes.from_now))
  end

  def far_past
    render(PracticalViews::RelativeTimeComponent.new(time: 5.days.ago))
  end
end
