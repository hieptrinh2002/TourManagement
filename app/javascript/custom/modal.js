
document.addEventListener("turbo:load", function() {
  const modal = new bootstrap.Modal(document.getElementById("modal-dialog"));
  document.getElementById("showModalButton").addEventListener("click", function() {
    modal.show();
  });
});
