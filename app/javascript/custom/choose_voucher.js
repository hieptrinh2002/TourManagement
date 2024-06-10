document.addEventListener("DOMContentLoaded", function() {
  var voucherCodes = document.querySelectorAll(".choose-voucher-item");

  voucherCodes.forEach(function(voucherCode) {
    voucherCode.addEventListener("click", function() {
      var voucherCodeInput = document.getElementById("voucher-code-input");
      var code = this.querySelector(".code").innerText;
      voucherCodeInput.value = code;
    });
  });
});
