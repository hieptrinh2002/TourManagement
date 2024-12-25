document.addEventListener("turbo:load", () => {
  const initializeStarRating = (stars, hiddenFieldId) => {
    stars.forEach(star => {
      star.addEventListener("click", function() {
        const rating = this.getAttribute("data-value");
        const starRatingEditBlock = star.parentElement

        // lấy và set value cho thẻ input ( số sao )
        const ratingFieldEdit = starRatingEditBlock.querySelector(hiddenFieldId);
        ratingFieldEdit.value = rating;

          // lấy ra tất cả các thẻ span chứa ngôi sao
        const fiveStars = starRatingEditBlock.querySelectorAll("span");

        // Reset stars
        fiveStars.forEach(s => {
          s.classList.remove("text-warning");
        });

        // Highlight stars up to the clicked one
        for (let i = 0; i < rating; i++) {
          fiveStars[i].classList.add("text-warning");
        }
      });
    });
  };

  const stars = document.querySelectorAll(".star-rating .star");
  initializeStarRating(stars, "#rating-field");

  const starEdits = document.querySelectorAll(".star-rating-edit .star-edit");
  initializeStarRating(starEdits, "#rating-field-edit");
});
