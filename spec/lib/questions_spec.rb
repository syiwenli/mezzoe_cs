require 'spec_helper'

describe Survey::Questions do
  describe "#start_question" do
    it "returns an array of the question id and the question" do
      expect(Survey::Questions.start_question.size).to eq(2)
      expect(Survey::Questions.start_question).to be_an(Array)
      expect(Survey::Questions.start_question.first).to be_an(Integer)
      expect(Survey::Questions.start_question.last).to be_an(String)
    end
  end

end