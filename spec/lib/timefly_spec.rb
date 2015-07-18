require 'spec_helper'

describe Timefly do
  before do
    allow(Time).to receive(:now).and_return Time.new(2015,6,3)
  end
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

  describe '#years_from_origin_time' do
    { [1987, 8, 2] => 27,
      [1987, 6, 2] => 27,
      [1987, 6, 3] => 28 }.each do |dob_arr, age|
      context "when origin_time is Time.new(#{dob_arr[0]}, #{dob_arr[1]}, #{dob_arr[2]})" do
        it "returns #{age}" do
          dob = Time.new(dob_arr[0], dob_arr[1], dob_arr[2])
          timefly = Timefly.new(dob)
          expect(
            timefly.send(:years_from_origin_time)
          ).to eq age
        end
      end
    end
  end
end