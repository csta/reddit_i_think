require "opal"
require "Net/HTTP"
require "JSON"
require "YAML"
require "Digest"

url="http://www.reddit.com/"
api_method = "search.json?"
parameters = ["q=i+think","limit=100","sort=new"].join("&")
uri = URI(url+api_method+parameters)
reddit_objs=JSON.parse((res=Net::HTTP.get_response(uri)).body)

before = JSON.parse(res.body)["data"]["after"]

reddit_array_of_objs = (reddit_objs)["data"]["children"]
#each will loop through each element in the array.
h = Hash.new
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
			puts "Appending : \n"
			File.open("text.txt", "a"){|file|file.write(str+"\n")}
			puts "Run lcd script."
			puts "Waiting of lcd to finish."
			puts h.size
			sleep 1	
		else
			puts "repeat...\n"
			puts str
		end
	end
end
File.open('data', 'a') {|f| f.write(YAML.dump(h))}
