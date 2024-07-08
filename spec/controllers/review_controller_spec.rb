# spec/controllers/reviews_controller_spec.rb
require "rails_helper"

RSpec.describe ReviewsController, type: :controller do
  let(:user) { create(:user, role: 0) }
  let(:tour) { create(:tour) }
  let(:review) { create(:review, tour: tour, user: user) }

  before do
    user.confirm
    sign_in user
  end

  describe "POST #create" do
    context "with valid attributes and existing booking" do
      before do
        allow(controller).to receive(:booking_exists_for_user_and_tour?).and_return(true)
      end
      it "creates a new review" do
        expect {
          post :create, params: { tour_id: tour.id, review: attributes_for(:review, tour_id: tour.id, user_id: user.id) }
        }.to change(Review, :count).by(1)
      end

      it "redirects to the tour page" do
        post :create, params: { tour_id: tour.id, review: attributes_for(:review, tour_id: tour.id, user_id: user.id) }
        expect(response).to redirect_to tour_path(tour)
      end

      it "sets flash[:danger] and redirects to tours_path on save failure" do
        allow_any_instance_of(Review).to receive(:save).and_return(false)
        post :create, params: { tour_id: tour.id, review: attributes_for(:review, tour_id: nil) }
        expect(flash[:danger]).to eq(I18n.t("flash.review.create_failed"))
        expect(response).to redirect_to(tours_path)
      end

    end

    context "without existing booking" do
      it "does not create a new review" do
        expect {
          post :create, params: { tour_id: tour.id, review: attributes_for(:review, tour_id: tour.id, user_id: user.id) }
        }.to change(Review, :count).by(0)
      end

      it "redirects to tours index with unprocessable_entity status" do
        post :create, params: { tour_id: tour.id, review: attributes_for(:review, tour_id: tour.id, user_id: user.id) }
        expect(response).to redirect_to(tours_path)
        expect(flash[:danger]).to eq(I18n.t("flash.review.review_denied"))
      end
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      let(:new_attributes) { { rating: 5 } }

      it "updates the requested review" do
        patch :update, params: {tour_id: tour.id, id: review.to_param, review: new_attributes }
        review.reload
        expect(review.rating).to eq(5)
      end

      it "redirects to the tour path after update" do
        patch :update, params: {tour_id: tour.id, id: review.to_param, review: new_attributes }
        expect(response).to redirect_to(tour_path(tour))
      end
    end

    context "with invalid params" do
      it "sets flash[:danger] and redirects to tours_path" do
        allow_any_instance_of(Review).to receive(:update).and_return(false)
        patch :update, params: {tour_id: tour.id, id: review.to_param, review: { rating: 5 } }
        expect(flash[:danger]).to eq(I18n.t("flash.review.update_failed"))
        expect(response).to redirect_to(tours_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when destroy succeeds" do
      it "destroys the requested review" do
        review  # Ensure the review is created before testing destroy
        expect {
          delete :destroy, params: { tour_id: tour.id, id: review.id }
        }.to change(Review, :count).by(-1)
      end

      it "redirects to the tour path after destroy" do
        delete :destroy, params: { tour_id: tour.id, id: review.id }
        expect(response).to redirect_to(tour_path(tour))
      end
    end

    context "when destroy fails" do
      it "sets flash[:danger] and redirects to tours_path" do
        allow_any_instance_of(Review).to receive(:destroy).and_return(false)
        delete :destroy, params: { tour_id: tour.id, id: review.id }
        expect(flash[:danger]).to eq(I18n.t("flash.review.destroy_failed"))
        expect(response).to redirect_to(tours_path)
      end
    end
  end
end
