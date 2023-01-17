RSpec.describe OJRA::Client do

  before(:each) do
    allow(Faraday).to receive(:post).and_return(double(status: 500))
  end

  describe ".configured?" do
    it "is true if Client initialized with host_url and token values" do
      client = OJRA::Client.new("https://reviewers-api.test", "testTOKEN")

      expect(client.configured?).to eq(true)
    end

    it "is false if host_url or token values are empty" do
      client = OJRA::Client.new("", "")
      expect(client.configured?).to eq(false)

      client = OJRA::Client.new(nil, nil)
      expect(client.configured?).to eq(false)

      client = OJRA::Client.new("https://reviewers-api.test", nil)
      expect(client.configured?).to eq(false)

      client = OJRA::Client.new("", "testTOKEN")
      expect(client.configured?).to eq(false)
    end
  end

  describe "When Client is not configured" do
    before do
      @client = OJRA::Client.new("", "")
      expect(@client).to receive(:configured?).and_return(false)
    end

    it ".assign_reviewer returns false" do
      expect{ @client.assign_reviewer("reviewer21", 1234) }.to raise_exception(OJRA::UnconfiguredAPI)
    end

    it ".assign_reviewers returns false" do
      expect{ @client.assign_reviewers("reviewer21", 1234) }.to raise_exception(OJRA::UnconfiguredAPI)
    end

    it ".unassign_reviewer returns false" do
      expect{ @client.unassign_reviewer("reviewer21", 1234) }.to raise_exception(OJRA::UnconfiguredAPI)
    end

    it ".unassign_reviewers returns false" do
      expect{ @client.unassign_reviewers("reviewer21", 1234) }.to raise_exception(OJRA::UnconfiguredAPI)
    end
  end

  describe "When Client is configured" do
    before do
      @client = OJRA::Client.new("https://reviewers-api.test", "testTOKEN")
    end

    describe ".assign_reviewer" do
      it "calls the Reviewers API assigning reviewer to issue" do
        expected_url = "https://reviewers-api.test/api/stats/update/reviewer21/review_assigned"
        expected_params = { idempotency_key: "assign-reviewer21-1234" }
        expected_headers = { "TOKEN" => "testTOKEN" }

        expect(Faraday).to receive(:post).with(expected_url, expected_params, expected_headers)

        @client.assign_reviewer("reviewer21", 1234)
      end

      it "returns whether or not response is 2XX" do
        expect(Faraday).to receive(:post).and_return(double(status: 200))
        expect(@client.assign_reviewer("reviewer21", 1234)).to eq(true)
        expect(@client.error_msg).to be_nil

        expect(Faraday).to receive(:post).and_return(double(status: 404))
        expect(@client.assign_reviewer("reviewer33", 5678)).to eq(false)
      end

      it "create message on errors" do
        expect(Faraday).to receive(:post).and_return(double(status: 403))

        @client.assign_reviewer("reviewer21", 1234)

        expect(@client.error_msg).to eq("Error response code: 403")
      end
    end

    describe ".unassign_reviewer" do
      it "calls the Reviewers API unassigning reviewer from issue" do
        expected_url = "https://reviewers-api.test/api/stats/update/reviewer21/review_unassigned"
        expected_params = { idempotency_key: "unassign-reviewer21-1234" }
        expected_headers = { "TOKEN" => "testTOKEN" }

        expect(Faraday).to receive(:post).with(expected_url, expected_params, expected_headers)

        @client.unassign_reviewer("reviewer21", 1234)
      end

      it "returns whether or not response is 2XX" do
        expect(Faraday).to receive(:post).and_return(double(status: 200))
        expect(@client.unassign_reviewer("reviewer21", 1234)).to eq(true)
        expect(@client.error_msg).to be_nil

        expect(Faraday).to receive(:post).and_return(double(status: 404))
        expect(@client.unassign_reviewer("reviewer33", 5678)).to eq(false)
      end

      it "create message on errors" do
        expect(Faraday).to receive(:post).and_return(double(status: 500))

        @client.unassign_reviewer("reviewer21", 1234)

        expect(@client.error_msg).to eq("Error response code: 500")
      end
    end

    describe ".assign_reviewers" do
      it "calls .assign_reviewer for each reviewer" do
        expect(@client).to receive(:assign_reviewer).once.with("reviewer21", 1234)
        expect(@client).to receive(:assign_reviewer).once.with("reviewer33", 1234)
        expect(@client).to receive(:assign_reviewer).once.with("reviewer42", 1234)

        @client.assign_reviewers(["reviewer21", "reviewer33", "reviewer42"], 1234)
      end

      it "can parse string of reviewers into an array" do
        expect(@client).to receive(:assign_reviewer).once.with("reviewer21", 1234)
        expect(@client).to receive(:assign_reviewer).once.with("reviewer33", 1234)
        expect(@client).to receive(:assign_reviewer).once.with("reviewer42", 1234)

        @client.assign_reviewers("reviewer21, reviewer33, reviewer42", 1234)
      end
    end

    describe ".unassign_reviewers" do
      it "calls .unassign_reviewer for each reviewer" do
        expect(@client).to receive(:unassign_reviewer).once.with("reviewer21", 1234)
        expect(@client).to receive(:unassign_reviewer).once.with("reviewer33", 1234)
        expect(@client).to receive(:unassign_reviewer).once.with("reviewer42", 1234)

        @client.unassign_reviewers(["reviewer21", "reviewer33", "reviewer42"], 1234)
      end

      it "can parse string of reviewers into an array" do
        expect(@client).to receive(:unassign_reviewer).once.with("reviewer21", 1234)
        expect(@client).to receive(:unassign_reviewer).once.with("reviewer33", 1234)
        expect(@client).to receive(:unassign_reviewer).once.with("reviewer42", 1234)

        @client.unassign_reviewers("reviewer21, reviewer33, reviewer42", 1234)
      end
    end


  end

end