# frozen_string_literal: true

require 'cli'

require_relative '../shared_examples/output_spec'

describe Cli do
  describe '#call' do
    subject(:object) { described_class.new(args) }

    context 'when no arguments provided' do
      let(:expectation) do
        "Please provide a file location so we can help you sort your itinerary details.\n"
      end
      let(:args) { [] }

      include_examples 'Output test', 'prompts about missing filepath'
    end

    context 'when invalid filepath is provided' do
      let(:expectation) do
        "Could not open the file abc. Please verify the file location.\n"
      end
      let(:args) { %w[abc] }

      before { allow(File).to receive(:open).and_raise(Errno::ENOENT) }

      include_examples 'Output test', 'prompts about invalid filepath'
    end

    context 'when valid filepath is provided' do
      let(:array_file_content) { ["Hotel in Madrid 23-05-23.\n", "Flight SEV -> MAD 23-05-2023 11:00\n\n"]  }
      let(:expectation) { "Hotel in Madrid 23-05-23.\nFlight SEV -> MAD 23-05-2023 11:00\n\n" }
      let(:file) { instance_double(File) }
      let(:args) { ['filepath'] }

      before do
        allow(file).to receive(:each_line).and_yield(array_file_content)
        allow(File).to receive(:open).and_return(array_file_content)
        allow_any_instance_of(ParseData).to receive(:call).and_return(array_file_content)
        allow_any_instance_of(SegmentManagement).to receive(:call).and_return(array_file_content)
      end

      include_examples 'Output test', 'reads the file'
    end
  end
end
