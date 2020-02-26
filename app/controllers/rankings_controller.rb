class RankingsController < ApplicationController

    def index
        rankings = Ranking.order(rank: :asc)[0..10]
        render json: basic_rankings_info(rankings)
    end

    private

    def basic_rankings_info(ranking)
        ranking.as_json(
            except: [:created_at, :updated_at],
            include: {
                user: {only: [:username]}
            }
        )
    end
end
