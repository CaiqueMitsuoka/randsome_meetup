RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_examples 'instance has attribute' do |instance, name, value|
  @name_s = name.to_s

  describe "##{@name_s}" do
    context 'only-read attribute' do
      it "respond to ##{@name_s}" do
        expect(instance).to respond_to(name)
      end

      it "raise and error if #{@name_s} is assigned" do
        expect { instance.send("#{@name_s}=", value) }.to raise_error(NoMethodError)
      end

      it "#{@name_s} is properly assined" do
        expect(instance.send(name)).to eq(value)
      end
    end
  end
end
