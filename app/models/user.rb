class User < ApplicationRecord
    has_secure_password
    attr_encrypted :genius_token, key: ENV['DB_SECRET']

    has_one :ranking, dependent: :destroy

    has_many :genre_scores, dependent: :destroy

    has_many :games, dependent: :destroy

    has_many :friendships, foreign_key: :friender_id, dependent: :destroy
    has_many :friends, through: :friendships, source: :friended

    has_many :frienders, through: :friendships, source: :friender

    validates :name, :username, :password, presence: true
    validates :username, uniqueness: true

    def calculate_genre_scores(genre)
        games = self.games.filter {|g| g.genre == genre}
        puts "genre is nil? #{genre.nil?} games: #{games}. games length #{games.length}"
        score = games.reduce(0) {|agg, g| agg + g.final_score }
        genre_score = GenreScore.find_or_create_by(genre: genre)
        genre_score.score = score
        genre_score.user = self
        genre_score.genre = genre
        genre_score.save
    end

    def calculate_ranking
        puts "+===================="
        puts "Calculating rankings"
        ranking = self.ranking ? self.ranking : Ranking.new(user: self)
        grand_total = self.genre_scores.reduce(0) {|agg, gs| agg + gs.score}
        ranking.total_score = grand_total
        res = ranking.save
        puts "Ranking save failed because #{ranking.errors.full_messages}" if !res
        rankings = Ranking.order('total_score desc')
        rankings.each_with_index do |r, i|
            r.rank = i
            r.save
        end
        # ranking.reload
        # ranking
    end

    check_perm 'users#show', 'users#index' do |user, current_user|
        !current_user.nil?
    end

    check_perm 'users#destroy', 'users#update' do |user, current_user|
        user == current_user
    end
end
