require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'via associations' do 
    it 'belongs to a  game' do
      game = Game.new
      question = game.questions.build

      expect(question.game).to eq(game)
    end
  end
end
