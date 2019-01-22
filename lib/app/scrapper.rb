class Scrapper

  @@name_and_email = []
  
   def url_and_name
     url = "http://annuaire-des-mairies.com/val-d-oise.html"
     doc = Nokogiri::HTML(open(url))
     url_path = doc.css("a[href].lientxt")
     name_and_url = []
  
     url_path.map do |value|
       url_ville = value["href"]
       url_ville[0] = ""
       name_and_url << { "name" => value.text, "url" => "http://annuaire-des-mairies.com" + url_ville }
     end
     name_and_url
   end
  
   def get_townhall_email(url)
     doc = Nokogiri::HTML(open(url))
     email = doc.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text
   end
  
   def get_all_email(name_and_url)
     @@name_and_email = []
  
     name_and_url.map.with_index do |value, i|
       @@name_and_email << {value["name"] => get_townhall_email(value["url"])}
     end
     @@name_and_email
   end
  
   def save_as_JSON
     json = File.open('/Users/mallaury/Desktop/semaine3/mon_projet/db/email.json', "w") do |f|
       f.write(@@name_and_email.to_json)
     end
   end
  
  
  

   def save_to_spreadsheet
  session = GoogleDrive::Session.from_config("config.json")
  ws = session.spreadsheet_by_key("1v-8l2WnCf8tsFLNPzQrifYNwhRaVsXGdlb6TxJtVJ1c").worksheets[0]
   #


 
  @@name_and_email.each.with_index do |k, i|
  ws[i+1, 1] = k.keys.to_s[2..-3]
  ws[i+1, 2] = k.values.to_s[2..-3]

  end
  ws.save
  
  end
  
  def save_as_csv
    
    CSV.open("./db/emails.csv", "wb") do |csv|
      @@name_and_email.each do |element|

        csv << [element.keys.join.to_s, element.values.join.to_s]
      end
    end 
  end 

    
   def perform
    puts get_all_email(url_and_name())
    save_to_spreadsheet
    save_as_csv 
  end
 end
  # scrap = Scrapper.new
  # scrap.perform