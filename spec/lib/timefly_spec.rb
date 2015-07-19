require 'spec_helper'

describe Timefly do
  context 'age methods' do
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

    describe '#age' do
      context 'when origin_time is Time' do
        it 'returns the correct age' do
          expect(
            Timefly.new(Time.new(1987,8,2)).age
          ).to eq 27
        end
      end
      context 'when origin_time is String' do
        ['-', '/', '.'].each do |separator|
          context "dob is separated by #{separator}" do
            it 'raises error' do
              expect(
                Timefly.new("1987#{separator}08#{separator}02").age
              ).to eq 27
            end
          end
        end
      end
      context 'when format is sent in options' do
        it 'returns years and months in the format' do
          expect(
            Timefly.new('1987.08.02').age({ format: '%y years, %m months' })
          ).to eq '27 years, 10 months'
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

    describe '#months_diff_from_origin_time_month' do
      { [1987, 8, 2] => 10,
        [1987, 6, 2] => 0,
        [1987, 6, 3] => 0,
        [1987, 5, 3] => 1,
        [1987, 7, 1] => 11 }.each do |dob_arr, months|
        context "when dob is Time.new(#{dob_arr[0]}, #{dob_arr[1]}, #{dob_arr[2]})" do
          it "returns #{months}" do
            dob = Time.new(dob_arr[0], dob_arr[1], dob_arr[2])
            timefly = Timefly.new(dob)
            expect(
              timefly.send(:months_diff_from_origin_time_month)
            ).to eq months
          end
        end
      end
    end
  end

  context 'time_elapsed methods' do
    describe '#time_diff_in_secs' do
      context 'time_diff is 1 min' do
        it 'returns 60' do
          allow(Time).to receive(:now).and_return Time.new(2015,6,3, 12, 12, 0)
          origin_time = Time.new(2015,6,3, 12, 11, 0)
          expect(
            Timefly.new(origin_time).send(:time_diff_in_secs)
          ).to eq 60
        end
      end
      context 'time_diff is 1 hour' do
        it 'returns 3600' do
          allow(Time).to receive(:now).and_return Time.new(2015,6,3, 13, 12, 0)
          origin_time = Time.new(2015,6,3, 12, 12, 0)
          expect(
            Timefly.new(origin_time).send(:time_diff_in_secs)
          ).to eq 3600
        end
      end
    end

    describe '#time_elapsed_in_seconds?' do
      origin_time = Time.new(2015, 6, 15, 12, 12, 30)
      {
        Time.new(2015, 6, 15, 12, 12, 12) => true,
        Time.new(2015, 6, 15, 12, 11, 31) => true,
        Time.new(2015, 6, 15, 12, 11, 30) => false,
        Time.new(2015, 6, 15, 12, 10, 30) => false,
        Time.new(2015, 6, 15, 11, 11, 30) => false,
        Time.new(2015, 6, 14, 12, 11, 30) => false,
        Time.new(2015, 5, 15, 12, 11, 30) => false,
        Time.new(2014, 6, 15, 12, 11, 30) => false,
      }.each do |time_now, result|
        context "Time.now is #{time_now} and origin_time is #{origin_time}" do
          it "returns #{result}" do
            allow(Time).to receive(:now).and_return time_now
            expect(
              Timefly.new(origin_time).send(:time_elapsed_in_seconds?)
            ).to eq result
          end
        end
      end
    end
    describe '#time_elapsed_in_minutes?' do
      origin_time = Time.new(2015, 6, 15, 12, 12, 30)
      {
        Time.new(2015, 6, 15, 12, 11, 30) => true,
        Time.new(2015, 6, 15, 11, 13, 30) => true,
        Time.new(2015, 6, 15, 11, 12, 30) => false,
        Time.new(2015, 6, 14, 12, 11, 30) => false,
        Time.new(2015, 5, 15, 12, 11, 30) => false,
        Time.new(2014, 6, 15, 12, 11, 30) => false,
      }.each do |time_now, result|
        context "Time.now is #{time_now} and origin_time is #{origin_time}" do
          it "returns #{result}" do
            allow(Time).to receive(:now).and_return time_now
            expect(
              Timefly.new(origin_time).send(:time_elapsed_in_minutes?)
            ).to eq result
          end
        end
      end
    end

    describe '#time_elapsed_in_hours?' do
      origin_time = Time.new(2015, 6, 15, 12, 12, 30)
      {
        Time.new(2015, 6, 15, 11, 12, 30) => true,
        Time.new(2015, 6, 14, 12, 12, 31) => true,
        Time.new(2015, 6, 14, 12, 12, 30) => false,
        Time.new(2015, 6, 14, 12, 11, 30) => false,
        Time.new(2015, 5, 15, 12, 11, 30) => false,
        Time.new(2014, 6, 15, 12, 11, 30) => false,
      }.each do |time_now, result|
        context "Time.now is #{time_now} and origin_time is #{origin_time}" do
          it "returns #{result}" do
            allow(Time).to receive(:now).and_return time_now
            expect(
              Timefly.new(origin_time).send(:time_elapsed_in_hours?)
            ).to eq result
          end
        end
      end
    end

    describe '#time_elapsed_in_days?' do
      origin_time = Time.new(2015, 6, 15, 12, 12, 30)
      {
        Time.new(2015, 6, 14, 12, 12, 30) => true,
        Time.new(2015, 5, 15, 12, 12, 31) => false,
        Time.new(2015, 5, 15, 12, 12, 30) => false,
        Time.new(2015, 5, 15, 12, 11, 30) => false,
        Time.new(2014, 6, 15, 12, 11, 30) => false,
      }.each do |time_now, result|
        context "Time.now is #{time_now} and origin_time is #{origin_time}" do
          it "returns #{result}" do
            allow(Time).to receive(:now).and_return time_now
            expect(
              Timefly.new(origin_time).send(:time_elapsed_in_days?)
            ).to eq result
          end
        end
      end
    end

    describe '#time_elapsed_in_months?' do
      origin_time = Time.new(2015, 6, 15, 12, 12, 30)
      {
        Time.new(2015, 5, 15, 12, 12, 30) => true,
        Time.new(2014, 5, 15, 12, 12, 31) => false,
        Time.new(2014, 5, 15, 12, 12, 30) => false
      }.each do |time_now, result|
        context "Time.now is #{time_now} and origin_time is #{origin_time}" do
          it "returns #{result}" do
            allow(Time).to receive(:now).and_return time_now
            expect(
              Timefly.new(origin_time).send(:time_elapsed_in_months?)
            ).to eq result
          end
        end
      end
    end
  end
end