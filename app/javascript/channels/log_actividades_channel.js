import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
    consumer.subscriptions.create({channel: "LogActividadesChannel", usuario_role: document.getElementById("usuario_role").getAttribute("value")}, {
        connected() {
        },
      
        disconnected() {
          // Called when the subscription has been terminated by the server
        },
      
        received(data) {
          if($("#notificaciones").length) {
            $("#notificaciones").html(data).fadeIn(1000);
          } else {
            $("<div class='alert alert-warning centered' id='notificaciones'>" + data + "<div>").appendTo("body").hide().fadeIn(1000);
          }

          $("#notificaciones").fadeOut(5000);
        }
      });      
})