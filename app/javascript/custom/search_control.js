document.addEventListener("turbo:load", function() {
  const btn = document.querySelector(".tours-btn");
  const form = document.querySelector(".tours-search");
  if (btn) {
    btn.addEventListener("click", () => {
      form.classList.toggle("active");
    });
  }
});
