import mrujs from 'mrujs'
import {
  handleJSONRedirectionEvent,
  resetOnAjaxSuccessEvent,
  focusOnAjaxSuccessEvent,
  removeFallbackErrorsOnResetEvent,
} from './chunks/v2-practical-framework'

document.addEventListener("ajax:complete", handleJSONRedirectionEvent)
document.addEventListener(`ajax:success`, resetOnAjaxSuccessEvent)
document.addEventListener(`ajax:success`, focusOnAjaxSuccessEvent)
document.addEventListener(`reset`, removeFallbackErrorsOnResetEvent)

mrujs.start()