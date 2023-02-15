import * as bootstrap from 'bootstrap'
import consumer from './cable';

const inboxId = document.body.getAttribute('inbox-id');

consumer.subscriptions.create({ channel: `ProfileContextChannel`, inbox: inboxId },
  {
    connected() {
      console.log(`Connected to ProfileContextChannel-${inboxId}`);
    },
    disconnect() {
      console.log(`Disconnected to ProfileContextChannel-${inboxId}`);
    },
    received(data) {
      switch (data.event) {
        case "ADMIN_DELETE_YOUR_PROFILE":
          this.adminDeleteAccount(data.payload);
          break;
        case "ADMIN_UPDATE_YOUR_PROFILE":
          this.adminUpdateAccount(data.payload);
          break;
        default:
          console.log("Unknown type", data);
      }
    },
    adminDeleteAccount(payload) {
      // This force logout the user
      window.location.replace('/');

    },
    adminUpdateAccount(payload) {
      this.renderToast(`Admin atualizou o seu perfil`)
    },

    renderToast(message) {
      $('#profile-live-toast-boby').text(message);
      const toastElement = document.getElementById('profile-live-toast')

      if (toastElement) {
        const toast = new bootstrap.Toast(toastElement);
        toast.show();
      }
    },
  }
)
