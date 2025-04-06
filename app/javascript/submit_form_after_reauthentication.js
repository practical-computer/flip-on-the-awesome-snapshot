import {getReauthenticationToken} from '@practical-computer/practical-framework/js/handlers/passkey-reauthentication-handler';

export async function submitFormEvent(event){
  event.preventDefault()
  event.stopImmediatePropagation()
  let form = event.currentTarget
  await getReauthenticationToken(form)
  form.submit()
}

console.debug("Legacy submit form after reauthentication Loaded")