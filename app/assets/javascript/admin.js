// Entry point for the build script in your package.json
import '@fortawesome/fontawesome-free/js/all'

import 'chartkick/chart.js'
import './components/upload/avatar'
import './components/upload/spreadsheet'
import './components/websocket/admin_channel'

import Rails from '@rails/ujs'
Rails.start();
