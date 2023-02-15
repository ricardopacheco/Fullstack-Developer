import * as bootstrap from 'bootstrap'
import consumer from './cable';

consumer.subscriptions.create('AdminContextChannel',
  {
    connected() {
      console.log(window.$)
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
      const message = `Admin created user ${user.fullname} with id ${user.id}.`;

      this.renderToast(message);
      this.addUserInTable(html);
    },
    profileCreateUser(payload) {
      const { user, html } = payload;
      const message = `User ${user.fullname} has registered and has just created his profile.`;

      this.renderToast(message);
      this.addUserInTable(html);
    },
    adminUpdateUser(payload) {
      const { user, html } = payload;
      const message = `Admin updated user ${user.fullname} with id ${user.id}.`;

      this.renderToast(message);
      this.updateUserInTable(user.id, html);
    },
    profileUpdateUser(payload) {
      const { user, html } = payload;
      const message = `User ${user.fullname} with id ${user.id} updated his profile.`;

      this.renderToast(message);
      this.updateUserInTable(user.id, html);
    },
    adminDeleteUser(payload) {
      const { user_id } = payload;
      const message = `User with id ${user_id} was removed by admin.`;

      this.renderToast(message);
      this.removeUserFromTable(user_id);
    },
    profileDeleteUser(payload) {
      const { user_id } = payload;
      const message = `User with id ${user_id} deleted your profile.`;

      this.renderToast(message);
      this.removeUserFromTable(user_id);
    },
    importSpreadsheet(payload) {
      const { total, html } = payload;
      const message = `${total} users were created by importing a spreadsheet.`;

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
