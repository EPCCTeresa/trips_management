# frozen_string_literal: true

RSpec.shared_examples 'Output test' do |description|
  it description do
    expect do
      object.call
    end.to output(expectation).to_stdout
  end
end
