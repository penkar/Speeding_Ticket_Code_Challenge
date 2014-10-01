class Tickets
	def self.timer(car_hash,camera_hash)
		speeders = {}
		car_hash.each do |plate,time|
			2.upto(4) do |x|
				t = (camera_hash[x]/ time[x]*60*60).round(2)
				create_ticket(plate,t) if t > 60
			end
		end
	end
	def self.create_ticket(plate,time)
		puts "Vehicle #{plate} broke the speed limit by #{(time-60).round(1)} mph."
	end
end

class Cameras
	attr_accessor :number, :dist
	@@camera_repo = {}
	def initialize(number,dist)
		miles = dist*0.00062137119
		if @@camera_repo.keys.count>0
			@@camera_repo.merge!({number=>miles-@@camera_repo.values.inject(:+)})
		else
			@@camera_repo[number]=miles
		end	
	end
	def self.repo
		@@camera_repo
	end

end

class TimeParse
	def self.parse(x)
		data = x.gsub(':','').gsub('.','')
		time = data[0..1].to_i*60*60+data[2..3].to_i*60+data[4..5].to_i
		return time
	end
end

class CarSpeed
	attr_accessor
	@@car_repo = Hash.new(0)
	def initialize(plate,camera,time)
		if @@car_repo.keys.include?(plate)
			@@car_repo[plate].merge!({camera=>time-@@car_repo[plate].values.inject(:+)})
		else
			@@car_repo[plate]={camera=>time}
		end
	end
	def self.repo
		@@car_repo
	end
end

file = File.new('data.txt')
file.each do |line| 
	if line.match(/^Vehicle/)
		sline = line.split()
		plate = sline[1..2].join(' ')
		camera = sline[5].to_i
		time = TimeParse.parse(sline[7])
		a = CarSpeed.new(plate,camera,time)
	end
	if line.match(/^Speed camera number/)
		sline = line.split()
		number = sline[3].to_i
		dist = sline[5].to_i
		b = Cameras.new(number,dist)
	end
end

Tickets.timer(CarSpeed.repo,Cameras.repo)
# Vehicle LO04 CHZ broke the speed limit by 3.4 mph.
# Vehicle LO04 CHZ broke the speed limit by 2.1 mph.
# Vehicle QW04 SQU broke the speed limit by 10.6 mph.
# Vehicle R815 FII broke the speed limit by 3.9 mph.