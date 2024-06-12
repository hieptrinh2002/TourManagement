document.addEventListener("turbo:load", () => {
  const radioButtons = document.querySelectorAll(".flight-ticket-radio");
  let selectedTicketId = null;

  const updateTotalPrice = () => {
    const flightTicketIdField = document.querySelector(".flight-ticket-id");
    flightTicketIdField.value = selectedTicketId;

    const guestNumber = document.querySelector(".number-of-guest");
    const ticketPrice = document.getElementById(`ticket-price-${selectedTicketId}`);
    const tourPrice = document.getElementById("tour-price-id");
    const totalTicketPrice = document.getElementById("total-ticket-price-id");
    const numberOfTicket = document.getElementById("number-ticket-id");
    const totalPrice = document.getElementById("total-booking-price");

    const ticketPriceValue = parseFloat(ticketPrice.textContent);
    const guestNumberValue = parseInt(guestNumber.value);
    const tourPriceValue = parseFloat(tourPrice.textContent);

    numberOfTicket.innerHTML = guestNumberValue;
    totalTicketPrice.innerHTML = ticketPriceValue * guestNumberValue;
    totalPrice.innerHTML = (ticketPriceValue * guestNumberValue + tourPriceValue).toFixed(2);
  };

  radioButtons.forEach(radioButton => {
    radioButton.addEventListener("change", () => {
      selectedTicketId = radioButton.value;
      updateTotalPrice();
    });
  });

  const guestNumber = document.querySelector(".number-of-guest");
  if(guestNumber){
    guestNumber.addEventListener("change", ()=>{
      if(selectedTicketId)
        updateTotalPrice();
    });
  }
});

document.addEventListener("DOMContentLoaded", function() {
  const voucherCodes = document.querySelectorAll(".choose-voucher-item");
  const voucherCodeInput = document.getElementById("voucher-code-input");
  const textCode = document.querySelector(".voucher-code")

  voucherCodes.forEach(function(voucherCode) {
    voucherCode.addEventListener("click", function() {
      const code = this.querySelector(".code").innerText;
      voucherCodeInput.value = code;
      textCode.innerHTML = code
    });
  });

  voucherCodeInput.addEventListener("change", () => {
    textCode.innerHTML = voucherCodeInput.value
  })
});
