// Entry point for the build script in your package.json
import '@fortawesome/fontawesome-free/js/all'

import './components/form_upload'
import './components/websocket/profile_channel'

import Rails from '@rails/ujs'
Rails.start();
