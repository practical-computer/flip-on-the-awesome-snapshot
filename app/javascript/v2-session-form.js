import {startConditionalMediation, submitFormEvent} from '@practical-computer/practical-framework/js/forms/session-form';

let form = document.querySelector(`[data-new-session-form]`)

startConditionalMediation(form)
form.addEventListener('submit', submitFormEvent)