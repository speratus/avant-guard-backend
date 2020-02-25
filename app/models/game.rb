class Game < ApplicationRecord
    include GameLogic
    belongs_to :user
    belongs_to :song
    belongs_to :genre

    has_many :questions, dependent: :destroy

    attr_accessor :lyrics

    validates :multiplier, :user, :song, :genre, presence: true

    check_perm 'games#create' do |game, user|
        !user.nil?
    end

    check_perm 'games#update', 'games#show', 'games#index' do |game, user|
        game.user == user
    end

    def self.construct(user, options)
        #SONG CHOOSING PROCEDURE
        #
        # 1. 50/50 chance to pick song in db or out of db
        # 2. If in db, select one from genre/artist
        # 3. If not in db, pick song in db, then lastfm for similar songs
        # 4. pick one from list and query for details
        # 5. save to db
        game = Game.new(user: user)
        if options['genre']
            genre = Genre.find_by(name: options['genre'])
            song = game.pick_song_from_genre(genre)
        elsif options['artist']
            artist = Artist.find_by(name: options['artist'])
            song = game.pick_song_from_artist(artist)
        else
            raise ArgumentError, 'You must specify either a genre or an artist!'
            return
        end
        game.song = song
        game.multiplier = game.calculate_multiplier(song.listens, song.release_date)
        game.save
        game.genre = song.genres.first

        qts = Question::QUESTION_TYPES.keys

        3.times do
            t = qts.sample
            question = Question.new(question_type: t, game: game)
            # puts "The question keys are: #{qts}"
            case t
            when :y
                # puts "#{song} was released on: #{song.release_date}"
                puts "#{song} was released on: #{song.release_date.split(' ')[2]}"
                question.answer = song.release_date.split(' ')[2][0..-2]
            when :al
                # puts "#{song} appears on the album #{song.album}"
                question.answer = song.album
            when :ar
                # puts "#{song} was written by #{song.artist.name}"
                question.answer = song.artist.name
            when :t
                # puts "#{song}'s name is #{song.title}'"
                question.answer = song.title
            end
            qts.delete(t)
            # puts "The answer to the question is: #{question.answer}"
            question.save
            game.questions << question
            # puts "============The question has an id of #{question.id}"
            # puts "+++++++++There were these errors with saving the question: #{question.errors.full_messages}" if question.errors.any?
        end

        game.save

        puts "The song is: #{game.song} with an artist name of #{game.song.artist.name} and artist of #{game.song.artist}"

        game.lyrics = game.lyrics_sample(game.song)
        game
    end
end
