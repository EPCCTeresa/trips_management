# frozen_string_literal: true

require 'rails_helper'
require 'parse_data'

require_relative '../shared_examples/output'

describe ParseData do
  describe '#call' do
    subject(:object) { described_class.new(file_handle) }

    let(:file_handle) { File.open(file_path, 'r') }

    context 'when file contains valid data' do
      let(:file_path) { File.expand_path('../fixtures/input_test', __dir__) }
      let(:expectation) do
        ['Train SVQ 2023-02-15 09:30 -> MAD 11:00
', 'Train MAD 2023-02-17 17:00 -> SVQ 19:30
', 'Hotel MAD 2023-02-15 -> 2023-02-17
']
      end

      it 'stores data' do
        expect(object.call).to eq(expectation)
      end
    end

    context 'when file contains invalid data' do
      let(:file_path) do
        File.expand_path('../fixtures/invalid_or_empty_file', __dir__)
      end

      it 'does not store anything' do
        expect(object.call).to match_array([])
      end
    end
  end
end
