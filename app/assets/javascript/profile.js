// Entry point for the build script in your package.json
import '@fortawesome/fontawesome-free/js/all'

import './components/upload/avatar'
import './components/websocket/profile_channel'

import Rails from '@rails/ujs'
Rails.start();
