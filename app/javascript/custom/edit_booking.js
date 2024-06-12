document.addEventListener("turbo:load", () => {
  const radioButtons = document.querySelectorAll(".flight-ticket-radio-edit");
  let selectedTicketId = null;

  radioButtons.forEach(radioButton => {
    radioButton.addEventListener("change", () => {
      selectedTicketId = radioButton.value;
      const flightTicketIdField = document.querySelector(".flight-ticket-edit");
      flightTicketIdField.value = selectedTicketId;
    });
  });
});
