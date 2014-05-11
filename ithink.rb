require "net/http"
require "json"
require "yaml"
require "digest"

url="http://www.reddit.com/"
api_method = "search.json?"
after=nil

if File.file?("data.yml")
	h=Hash.new
	h=(YAML::load_file('data.yml')).to_hash
else
	h=Hash.new
end

while 1
	if after.nil?
		puts "after is nil"
		parameters = ["q=i+think","limit=100","sort=new"].join("&")
	else
		puts "after is "+after
		parameters = ["q=i+think","limit=100","sort=new","after="+after].join("&")
	end
	uri = URI(url+api_method+parameters)
	reddit_objs=JSON.parse((res=Net::HTTP.get_response(uri)).body)

	after = JSON.parse(res.body)["data"]["after"]

	reddit_array_of_objs = (reddit_objs)["data"]["children"]
	#each will loop through each element in the array.
	reddit_array_of_objs.each do  |x|
		#get the sentence from the object
		sentence=x["data"]["selftext"]
		#Get match to 'i think' in lowercase letters.
		str = /i think.*/.match(sentence.downcase).to_s
		str = /[^.,!?:;]+/.match(str).to_s

		if (str!="")&&(true==((/.*http*./=~str).nil?))&&(str.size>=20)&&(true==(/.*r\/*./=~str).nil?)&&((/\(/=~str).nil?)&&((/\)/=~str).nil?)
			#md5 value is the result of the MD5 Hash function.
			#If you don't know what a hash is: it is a key.
			md5 = Digest::MD5.digest(str)
			if h[md5].nil?
				h[md5] = str
				puts "Run lcd script with \""+str+"\""
				
				puts "Waiting of lcd to finish."
				puts h.size
				sleep 2
			else
				#puts "repeat...\n"
			end
		end
	end
	puts "Writing data please wait.."
	File.open('data.yml', 'w') {|f| f.write h.to_yaml}
	puts "All done."
end
