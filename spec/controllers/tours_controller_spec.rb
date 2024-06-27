require "rails_helper"

RSpec.describe ToursController, type: :controller do
  describe "GET #index" do
    before do
      @tour_1 = create(:tour, tour_name: "Halong Bay Cruise", city: "Ha Long", tour_destination: "Quang Ninh", status: :active)
      @tour_2 = create(:tour, tour_name: "Hoi An Ancient Town", city: "Hoi An", tour_destination: "Quang Nam", status: :removed)
      @tour_3 = create(:tour, tour_name: "Cho Noi", city: "Ninh Kieu", tour_destination: "Can Tho", status: :preparing)
      @tour_4 = create(:tour, tour_name: "Cu Chi Tunnels", city: "Sai Gon", tour_destination: "Ho Chi Minh City", status: :preparing)
      @tours = [@tour_1, @tour_2, @tour_3, @tour_4]
      get :index
    end

    context "with no search parameters" do
      it "returns all tours" do
        expect(assigns(:tours)).to match_array(@tours)
      end
    end

    context "with search by tour name" do
      let(:search_params) {{q: {tour_name_cont: "Halong"}}}

      it "returns tours matching the name" do
        get :index, params: search_params
        expect(assigns(:tours)).to eq([@tour_1])
      end
    end
    
    context "with search by address" do
      let(:search_params_1) {{q: {address_cont: "Ha Long"}}}
      let(:search_params_2) {{q: {address_cont: "Quang Nam"}}}
      let(:search_params_3) {{q: {address_cont: "Ninh"}}}

      it "returns tours matching the city" do
        get :index, params: search_params_1
        expect(assigns(:tours)).to eq([@tour_1])
      end

      it "returns tours matching the destination" do
        get :index, params: search_params_2
        expect(assigns(:tours)).to eq([@tour_2])
      end

      it "returns tours matching both the city and destination" do
        get :index, params: search_params_3
        expect(assigns(:tours)).to eq([@tour_1, @tour_3])
      end
    end

    context "with search by statuses" do
      let(:search_params) {{statuses: ["0"]}}

      it "returns tours matching the statuses" do
        get :index, params: search_params
        expect(assigns(:tours)).to eq([@tour_3, @tour_4])
      end
    end

    it "assigns @pagy" do
      expect(assigns(:pagy)).not_to be_nil
    end

    it "renders the index template" do
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    let!(:user) {create(:user)}
    let!(:tour) {create(:tour)}
    let!(:tours) {create_list(:tour, 3, tour_type_id: tour.tour_type_id)}
    let!(:reviews) {create_list(:review, 2, tour_id: tour.id, user_id: user.id)}
    
    context "with a valid tour id" do
      before do
        get :show, params: { id: tour.id }
      end

      it "assigns the requested tour to @tour" do
        expect(assigns(:tour)).to eq(tour)
      end

      it "paginates relevant tours by tour type" do
        expect(assigns(:relevant_pagy)).not_to be_nil
        expect(assigns(:relevant_tours).count).to eq(4)
      end

      it "assigns all reviews for the tour" do
        expect(assigns(:reviews).count).to eq(2)
      end
    end

    context "with a valid tour id" do
      before do
        get :show, params: {id: -16}
      end

      it "redirects to root_path" do
        expect(response).to redirect_to(tours_path)
      end

      it "flash a danger noti" do
        expect(flash[:danger]).to eq(I18n.t("flash.tour.find_tour_failed"))
      end
    end
  end
end
