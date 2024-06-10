document.addEventListener("DOMContentLoaded", (event) => {
  const carousel = document.querySelector("#myCarousel");
  const slides = Array.from(carousel.querySelectorAll(".carousel-inner .carousel-item"));
  let currentIndex = slides.findIndex(slide => slide.classList.contains("active"));

  carousel.querySelector(".left.carousel-btn").addEventListener("click", () => {
    slides[currentIndex].classList.remove("active");
    currentIndex = (currentIndex - 1 + slides.length) % slides.length;
    slides[currentIndex].classList.add("active");
  });

  carousel.querySelector(".right.carousel-btn").addEventListener("click", () => {
    slides[currentIndex].classList.remove("active");
    currentIndex = (currentIndex + 1) % slides.length;
    slides[currentIndex].classList.add("active");
  });
});
