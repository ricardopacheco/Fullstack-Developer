import * as bootstrap from 'bootstrap'
import consumer from './cable';

consumer.subscriptions.create('AdminContextChannel',
  {
    connected() {
      console.log("Connected to AdminContextChannel");
    },
    disconnect() {
      console.log("Disconnected to AdminContextChannel");
    },
    received(data) {
      switch (data.event) {
        case "ADMIN_CREATE_USER":
          this.adminCreateUser(data.payload);
          break;
        case "PROFILE_CREATE_USER":
          this.profileCreateUser(data.payload);
          break;
        case "ADMIN_UPDATE_USER":
          this.adminUpdateUser(data.payload);
          break;
        case "PROFILE_UPDATE_USER":
          this.profileUpdateUser(data.payload);
          break;
        case "ADMIN_DELETE_USER":
          this.adminDeleteUser(data.payload);
          break;
        case "PROFILE_DELETE_USER":
          this.profileDeleteUser(data.payload);
          break;
        case "ADMIN_IMPORT_SPREADSHEET":
          this.importSpreadsheet(data.payload);
          break;
        default:
          console.log("Unknown type", data);
      }
    },
    adminCreateUser(payload) {
      const { user, html } = payload;
      const message = `Admin criou um novo usuário chamado ${user.fullname} com id ${user.id}.`;

      this.renderToast(message);
      this.addUserInTable(html);
    },
    profileCreateUser(payload) {
      const { user, html } = payload;
      const message = `Usuário ${user.fullname} se registrou e acaba de criar o seu perfil.`;

      this.renderToast(message);
      this.addUserInTable(html);
    },
    adminUpdateUser(payload) {
      const { user, html } = payload;
      const message = `Admin atualizou o usuário ${user.fullname} com id ${user.id}.`;

      this.renderToast(message);
      this.updateUserInTable(user.id, html);
    },
    profileUpdateUser(payload) {
      const { user, html } = payload;
      const message = `Usuário ${user.fullname} with id ${user.id} atualizou o seu perfil.`;

      this.renderToast(message);
      this.updateUserInTable(user.id, html);
    },
    adminDeleteUser(payload) {
      const { user_id } = payload;
      const message = `Usuário com id ${user_id} foi removido via admin.`;

      this.renderToast(message);
      this.removeUserFromTable(user_id);
    },
    profileDeleteUser(payload) {
      const { user_id } = payload;
      const message = `Usuário com id ${user_id} deletou o seu perfil.`;

      this.renderToast(message);
      this.removeUserFromTable(user_id);
    },
    importSpreadsheet(payload) {
      const { total, html } = payload;
      const message = `${total} usuários foram criados por importação de panilha.`;

      this.renderToast(message);
      this.addUserInTable(html);
    },

    renderToast(message) {
      $('#admin-live-toast-boby').text(message);
      const toastElement = document.getElementById('admin-live-toast')

      if (toastElement) {
        const toast = new bootstrap.Toast(toastElement);
        toast.show();
      }
    },

    addUserInTable(html) {
      const table = $('#admin-users-table');

      if (table) {
        table.prepend(html);
      }
    },
    updateUserInTable(user_id, html) {
      const table = $('#admin-users-table');
      const row = table.find(`tr[data-user-id="${user_id}"]`);

      if (row) {
        row.remove();
        table.prepend(html);
      }
    },
    removeUserFromTable(user_id) {
      const table = $('#admin-users-table');
      const row = table.find(`tr[data-user-id="${user_id}"]`);

      if (row) {
        row.remove();
      }
    }
  }
)
