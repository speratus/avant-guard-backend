class RankingsController < ApplicationController

    def index
        rankings = Ranking.order(rank: :asc)
        render json: rankings
    end

    private

    def basic_rankings_info(ranking)
        ranking.as_json(except: [:created_at, :updated_at])
    end
end
