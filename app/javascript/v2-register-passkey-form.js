import {submitFormEvent} from '@practical-computer/practical-framework/js/forms/registration-form';

let form = document.querySelector(`[data-register-passkey-form]`)

form.addEventListener('submit', submitFormEvent)