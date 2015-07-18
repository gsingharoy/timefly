require 'spec_helper'

describe Timefly do

  describe '#process' do
    context 'origin_time is Date' do
      it 'retains the origin_time' do
        origin_date = Date.new(2015, 4, 6)
        timefly = Timefly.new(origin_date)
        expect(timefly.origin_time).to eq origin_date
      end
    end
    context 'origin_time is Time' do
      it 'retains the origin_time' do
        origin_time = Time.new(2015, 4, 6)
        timefly = Timefly.new(origin_time)
        expect(timefly.origin_time).to eq origin_time
      end
    end

    context 'origin_time is String' do
      context 'date like string' do
        ['.', '/', '-'].each do |separator|
          context "separated by #{separator}" do
            it 'converts the origin_time to Time' do
              origin_time = "1989#{separator}01#{separator}24"
              timefly = Timefly.new(origin_time)
              expect(timefly.origin_time).to eq Time.new(1989, 1, 24)
            end
          end
        end
      end
    end

    context 'origin_time is Fixnum' do
      it 'fails' do
        expect{ Timefly.new(1) }.to raise_error
      end
    end

    context 'origin_time is Float' do
      it 'fails' do
        expect{ Timefly.new(1.0) }.to raise_error
      end
    end
  end
end