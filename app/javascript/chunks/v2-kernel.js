import mrujs from 'mrujs'
import {
  handleJSONRedirectionEvent,
  resetOnAjaxSuccessEvent,
  focusOnAjaxSuccessEvent,
  removeFallbackErrorsOnResetEvent,
  ensureDeclarativeOpenModalDialogsAreModal,
  removeDisabledSinceJsLoaded,
} from './v2-practical-framework'

document.addEventListener(`DOMContentLoaded`, ensureDeclarativeOpenModalDialogsAreModal)
document.addEventListener(`DOMContentLoaded`, removeDisabledSinceJsLoaded)
document.addEventListener("ajax:complete", handleJSONRedirectionEvent)
document.addEventListener(`ajax:success`, resetOnAjaxSuccessEvent)
document.addEventListener(`ajax:success`, focusOnAjaxSuccessEvent)
document.addEventListener(`reset`, removeFallbackErrorsOnResetEvent)

mrujs.start()