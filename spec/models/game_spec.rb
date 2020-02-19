require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'via associations' do
    it 'has many questions' do
      game = Game.new

      3.times do
        game.questions.build
      end

      expect(game.questions.length).to eq 3
    end
  end
end
