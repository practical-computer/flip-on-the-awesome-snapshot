import mrujs from 'mrujs'

import { handleJSONRedirectionEvent } from './practical-framework'

document.addEventListener("ajax:complete", handleJSONRedirectionEvent)

mrujs.start()