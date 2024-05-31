document.addEventListener("turbo:load", () => {
    let account = document.querySelector(".dropdown");
    account.addEventListener("click", e => {
      let menu = document.querySelector(".dropdown-menu");
      menu.classList.toggle("dropdown-active");
      if (!menu.contains(e.target)) {
        e.preventDefault();
      }
    });
  });
