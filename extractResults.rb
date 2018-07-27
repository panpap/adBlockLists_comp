require 'descriptive_statistics'

def makeCDFs(col,total,filename)
    parts=filename.gsub(".csv","")
    system("awk -F\"\t\" '{print $"+col.to_s+"}' "+filename+" | sort -g | uniq -c | awk '{print $2\"\t\"$1\"\t\"$1*100/"+total.to_s+"}' | awk 'NR==1{print \"numOfSyncs\toccurences\tperc\tcdf\"} {s=s+$3;print $1\"\t\"$2\"\t\"$3\"\t\"s}' > "+parts+"_cdf.csv")
end


def mean(arr)
	return  arr.inject{ |sum, el| sum + el }.to_f / arr.size
end

easy=Array.new
privacy=Array.new
regional=Array.new
f1=File.new("easyListResults_"+ARGV[0],'w')
f2=File.new("easyPrivacyResults_"+ARGV[0],'w')
f3=File.new("easyChinaResults_"+ARGV[0],'w')
File.foreach(ARGV[0]){|line|
	if line.include? "blocked"
		if line.include? "EasyList"
			easy.push(line.split("blocked:").last.to_i)
			f1.puts line.split("blocked:").last.to_i
		end
		if line.include? "EasyPrivacy"
			privacy.push(line.split("blocked:").last.to_i) 
			f2.puts line.split("blocked:").last.to_i
		end
		if line.include? "China"
			regional.push(line.split("blocked:").last.to_i)
			f3.puts line.split("blocked:").last.to_i
		end
	end
}
puts "Median EasyList: "+easy.percentile(50).to_s
puts "Median EasyPrivacy: "+privacy.percentile(50).to_s
puts "Median EasyChina:"+regional.percentile(50).to_s
puts "Mean EasyList: "+mean(easy).to_s
puts "Mean EasyPrivacy: "+mean(privacy).to_s
puts "Mean EasyChina: "+mean(regional).to_s
f1.close
f2.close
f3.close
makeCDFs(1,20,"easyChinaResults_"+ARGV[0])
makeCDFs(1,20,"easyPrivacyResults_"+ARGV[0])
makeCDFs(1,20,"easyListResults_"+ARGV[0])