# frozen_string_literal: true

require 'rails_helper'
require 'parse_data'

describe SegmentManagement do
  describe '#call' do
    subject(:object) { described_class.new(file_handle) }

    let(:file_handle) { File.open(file_path, 'r') }
    let(:parsed_data) { ParseData.new(file_handle).call }

    context 'when file contains valid data with stay and round trip information' do
      let(:file_path) { File.expand_path('../fixtures/input_round_trip_stay', __dir__) }
      let(:expectation) { {"Trip to MAD" => ["Train SVQ 2023-02-15 09:30 -> MAD 11:00\n", "Hotel MAD 2023-02-15 -> 2023-02-16\n", "Hotel MAD 2023-02-16 -> 2023-02-17\n", "Train MAD 2023-02-17 17:00 -> SVQ 19:30\n"] } }

      it 'stores data' do
        expect(object.call).to eq(expectation)
      end
    end

    context 'when file contains valid data with stay and round trip information' do
      let(:file_path) { File.expand_path('../fixtures/input_just_round_trip', __dir__) }
      let(:expectation) { {"Trip to SEV" => ["Train SVQ 2023-02-15 09:30 -> MAD 11:00\n",  "Train MAD 2023-02-16 08:00 -> SEV 19:30\n"] } }

      it 'stores data' do
        expect(object.call).to eq(expectation)
      end
    end

    context 'when file contains invalid data' do
      let(:file_path) do
        File.expand_path('../fixtures/invalid_or_empty_file', __dir__)
      end

      it 'does not store anything' do
        expect{object.call}.to raise_error(ArgumentError)
      end
    end
  end
end
